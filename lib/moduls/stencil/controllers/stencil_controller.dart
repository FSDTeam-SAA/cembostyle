import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:cembostyle/core/network/api_client.dart';
import 'package:cembostyle/core/network/constants/api_constants.dart';
import 'package:cembostyle/moduls/home/controllers/home_controller.dart';
import '../data/stencil_dummy_data.dart';
import '../models/stencil_models.dart';

class StencilController extends GetxController {
  StencilController();

  final ApiClient _apiClient = Get.find<ApiClient>();
  final ImagePicker _picker = ImagePicker();
  bool _hasLoadedLibrary = false;

  final RxInt selectedStyleIndex = 0.obs;
  final RxInt selectedColorThemeIndex = 0.obs;
  final RxInt selectedDetailLevel = 1.obs;
  final RxDouble compareValue = 0.55.obs;
  final RxDouble brightness = 0.8.obs;
  final RxDouble contrast = 0.6.obs;
  final RxBool isRecentActivityLoading = false.obs;
  final RxBool isGenerating = false.obs;
  final RxBool isSavingToGallery = false.obs;
  final RxBool isDownloading = false.obs;
  final RxString recentActivityError = ''.obs;
  final RxString generationError = ''.obs;

  final Rxn<File> selectedImageFile = Rxn<File>();
  final Rxn<StencilRecord> activeStencil = Rxn<StencilRecord>();
  final RxList<StencilActivityItem> recentActivities =
      <StencilActivityItem>[].obs;

  List<StencilStyleOption> get stencilStyles => StencilDummyData.stencilStyles;
  List<ColorThemeOption> get colorThemes => StencilDummyData.colorThemes;
  List<StencilSampleImage> get samples => StencilDummyData.samples;

  StencilStyleOption get selectedStyle => stencilStyles[selectedStyleIndex.value];
  ColorThemeOption get selectedColorTheme =>
      colorThemes[selectedColorThemeIndex.value];

  Future<void> ensureLoaded() async {
    if (_hasLoadedLibrary) {
      return;
    }

    _hasLoadedLibrary = true;
    await fetchRecentActivities();
  }

  Future<bool> pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 92,
        maxWidth: 2048,
      );

      if (picked == null) {
        return false;
      }

      selectedImageFile.value = File(picked.path);
      activeStencil.value = null;
      generationError.value = '';
      compareValue.value = 0.55;
      return true;
    } catch (error) {
      Get.snackbar('Image', 'Could not pick the image. $error');
      return false;
    }
  }

  void updateCompare(double value) {
    compareValue.value = value.clamp(0.05, 0.95);
  }

  void applyStencilRecord(StencilRecord record) {
    activeStencil.value = record;
    generationError.value = '';
    selectedImageFile.value = null;
    _syncSelectedOptions(record);
  }

  Future<void> refreshRecentActivities() async {
    await fetchRecentActivities();
  }

  void _refreshHomeActivities() {
    try {
      final homeCtrl = Get.find<HomeController>();
      homeCtrl.refreshRecentActivities();
    } catch (_) {}
  }

  Future<void> fetchRecentActivities() async {
    recentActivityError.value = '';
    isRecentActivityLoading.value = true;

    final result = await _apiClient.get<List<StencilRecord>>(
      endpoint: ApiConstants.stencil.getMyAllStencils,
      fromJsonT: (json) {
        if (json is! List) {
          return <StencilRecord>[];
        }

        return json
            .whereType<Map<String, dynamic>>()
            .map(StencilRecord.fromApi)
            .toList();
      },
    );

    result.fold(
      (failure) {
        recentActivityError.value = failure.message;
      },
      (success) {
        final records = success.data.toList();
        records.sort(_compareByDateDesc);
        recentActivities.assignAll(records.map(_mapToStencilActivity));
      },
    );

    isRecentActivityLoading.value = false;
  }

  Future<bool> generateStencil() async {
    final sourceFile = await _createSourceFile();
    if (sourceFile == null) {
      generationError.value =
          'Select an image first or open a stencil with an original image to regenerate.';
      Get.snackbar('Stencil', generationError.value);
      return false;
    }

    generationError.value = '';
    isGenerating.value = true;

    final formData = dio.FormData.fromMap({
      'file': sourceFile,
      'style': selectedStyle.title,
      'colorTheme': selectedColorTheme.title,
      'detailLevel': selectedDetailLevel.value,
      'brightness': brightness.value,
      'contrast': contrast.value,
    });

    final result = await _apiClient.post<StencilRecord>(
      endpoint: ApiConstants.stencil.create,
      formData: formData,
      fromJsonT: (json) => StencilRecord.fromApi(json as Map<String, dynamic>),
      options: dio.Options(
        sendTimeout: const Duration(minutes: 3),
        receiveTimeout: const Duration(minutes: 5),
      ),
    );

    isGenerating.value = false;

    return result.fold(
      (failure) {
        generationError.value = failure.message;
        Get.snackbar('Stencil', failure.message);
        return false;
      },
      (success) async {
        final record = success.data;
        activeStencil.value = record;
        compareValue.value = 0.55;
        _syncSelectedOptions(record);
        await fetchRecentActivities();
        return true;
      },
    );
  }

  List<String> get _stencilDownloadUrls {
    final record = activeStencil.value;
    final base = record?.baseStencilImageUrl ?? '';
    final stencil = record?.stencilImageUrl ?? '';
    final urls = <String>[];
    if (base.isNotEmpty) urls.add(base);
    if (stencil.isNotEmpty && stencil != base) urls.add(stencil);
    return urls;
  }

  Future<Uint8List?> _downloadStencilBytes() async {
    for (final url in _stencilDownloadUrls) {
      final bytes = await _downloadBytes(url);
      if (bytes != null && bytes.isNotEmpty) return bytes;
    }
    return null;
  }

  Future<void> shareActiveStencil() async {
    if (_stencilDownloadUrls.isEmpty) {
      Get.snackbar('Share', 'There is no generated stencil to share yet.');
      return;
    }

    try {
      final bytes = await _downloadStencilBytes();
      if (bytes == null) {
        Get.snackbar('Share', 'Could not load the stencil image.');
        return;
      }

      final dir = await getTemporaryDirectory();
      final url = _stencilDownloadUrls.first;
      final ext = url.toLowerCase().contains('.png') ? 'png' : 'jpg';
      final file = File('${dir.path}/bheppo_stencil.$ext');
      await file.writeAsBytes(bytes, flush: true);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'My Bheppo stencil',
        ),
      );
    } catch (error) {
      Get.snackbar('Share', 'Could not share the stencil. $error');
    }
  }

  Future<void> downloadStencil(String format) async {
    if (_stencilDownloadUrls.isEmpty) {
      Get.snackbar('Download', 'There is no generated stencil to download yet.');
      return;
    }

    if (isDownloading.value) return;
    isDownloading.value = true;

    try {
      final imageBytes = await _downloadStencilBytes();
      if (imageBytes == null) {
        throw Exception('Could not download the stencil image.');
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;

      if (format == 'pdf') {
        final directory = await _resolveDownloadDirectory();
        await directory.create(recursive: true);
        await _saveAsPdf(imageBytes, directory, timestamp);
        Get.snackbar(
          'Download complete',
          'PDF saved to Downloads.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      } else {
        final ext = format == 'png' ? 'png' : 'jpg';
        final tempDir = await getTemporaryDirectory();
        final tempFile = File('${tempDir.path}/bheppo_stencil_$timestamp.$ext');
        await tempFile.writeAsBytes(imageBytes, flush: true);
        await Gal.putImage(tempFile.path, album: 'Bheppo Stencil');
        Get.snackbar(
          'Saved to Photos',
          '${ext.toUpperCase()} saved to your photo gallery.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (error) {
      if (error is GalException) {
        Get.snackbar(
          'Permission needed',
          'Please allow photo library access to save images.',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar('Download', 'Could not save the stencil. $error');
      }
    } finally {
      isDownloading.value = false;
    }
  }

  Future<File> _saveAsPdf(
    Uint8List imageBytes,
    Directory directory,
    int timestamp,
  ) async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(imageBytes);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Center(
            child: pw.Image(
              image,
              fit: pw.BoxFit.contain,
              width: PdfPageFormat.a4.availableWidth,
            ),
          );
        },
      ),
    );

    final file = File('${directory.path}/bheppo_stencil_$timestamp.pdf');
    await file.writeAsBytes(await pdf.save(), flush: true);
    return file;
  }

  Future<void> markAsSaved() async {
    final record = activeStencil.value;
    if (record == null) {
      Get.snackbar('Save', 'Generate a stencil before saving it.');
      return;
    }

    if (record.isSaved) {
      Get.snackbar(
        'Saved to My Stencils',
        'This stencil is already saved in My Stencils.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (isSavingToGallery.value) {
      return;
    }

    isSavingToGallery.value = true;

    final result = await _apiClient.patch<StencilRecord>(
      endpoint: ApiConstants.stencil.byId(record.id),
      data: {'isSaved': true},
      fromJsonT: (json) => StencilRecord.fromApi(json as Map<String, dynamic>),
    );

    isSavingToGallery.value = false;

    result.fold(
      (failure) {
        Get.snackbar('Save', failure.message);
      },
      (success) async {
        activeStencil.value = success.data;
        await fetchRecentActivities();
        _refreshHomeActivities();
        Get.snackbar(
          'Saved to My Stencils',
          'Your stencil has been added to My Stencils.',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
    );
  }


  Future<dio.MultipartFile?> _createSourceFile() async {
    final localFile = selectedImageFile.value;
    if (localFile != null) {
      return dio.MultipartFile.fromFile(
        localFile.path,
        filename: localFile.path.split('/').last,
      );
    }

    final originalUrl = activeStencil.value?.originalImageUrl ?? '';
    if (originalUrl.isEmpty) {
      return null;
    }

    try {
      final response = await dio.Dio().get<List<int>>(
        originalUrl,
        options: dio.Options(responseType: dio.ResponseType.bytes),
      );
      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) {
        return null;
      }

      final uri = Uri.tryParse(originalUrl);
      final lastSegment = uri != null && uri.pathSegments.isNotEmpty
          ? uri.pathSegments.last
          : 'stencil-source.jpg';
      final filename = lastSegment.contains('.')
          ? lastSegment
          : '$lastSegment.jpg';

      return dio.MultipartFile.fromBytes(bytes, filename: filename);
    } catch (_) {
      return null;
    }
  }

  Future<Directory> _resolveDownloadDirectory() async {
    if (Platform.isAndroid) {
      final publicDownloads = Directory('/storage/emulated/0/Download');
      if (await publicDownloads.exists()) {
        return publicDownloads;
      }
    }

    final directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  Future<Uint8List?> _downloadBytes(String url) async {
    try {
      final response = await dio.Dio().get<List<int>>(
        url,
        options: dio.Options(
          responseType: dio.ResponseType.bytes,
          receiveTimeout: const Duration(seconds: 60),
          followRedirects: true,
        ),
      );
      final bytes = response.data;
      if (bytes == null || bytes.isEmpty) {
        return null;
      }
      return Uint8List.fromList(bytes);
    } catch (e) {
      if (kDebugMode) print('Download failed for $url: $e');
      return null;
    }
  }

  int _compareByDateDesc(StencilRecord a, StencilRecord b) {
    final aDate = _parseDate(a.createdAt);
    final bDate = _parseDate(b.createdAt);
    if (aDate == null && bDate == null) {
      return 0;
    }
    if (aDate == null) {
      return 1;
    }
    if (bDate == null) {
      return -1;
    }
    return bDate.compareTo(aDate);
  }

  StencilActivityItem _mapToStencilActivity(StencilRecord record) {
    final stencilThumb = record.baseStencilImageUrl.isNotEmpty
        ? record.baseStencilImageUrl
        : record.stencilImageUrl;
    return StencilActivityItem(
      id: record.id,
      title: _buildTitle(record.status),
      style: _buildStyleLabel(record.style, record.status),
      date: _formatDate(record.createdAt),
      thumbnailUrl: stencilThumb.isNotEmpty
          ? stencilThumb
          : record.originalImageUrl,
      styleName: record.style,
      originalImageUrl: record.originalImageUrl,
      stencilImageUrl: stencilThumb,
      baseStencilImageUrl: record.baseStencilImageUrl,
      status: record.status,
      errorMessage: record.errorMessage,
      colorTheme: record.colorTheme,
      detailLevel: record.detailLevel,
      isSaved: record.isSaved,
    );
  }

  void _syncSelectedOptions(StencilRecord record) {
    final styleIndex = stencilStyles.indexWhere(
      (style) => style.title == record.style,
    );
    if (styleIndex >= 0) {
      selectedStyleIndex.value = styleIndex;
    }

    final themeIndex = colorThemes.indexWhere(
      (theme) => theme.title == record.colorTheme,
    );
    if (themeIndex >= 0) {
      selectedColorThemeIndex.value = themeIndex;
    }

    selectedDetailLevel.value = record.detailLevel.clamp(0, 2);
    brightness.value = record.brightness.clamp(0.0, 1.0);
    contrast.value = record.contrast.clamp(0.0, 1.0);
  }

  String _buildTitle(String status) {
    if (status.isEmpty) {
      return 'Stencil created';
    }
    final label = _prettyStatus(status);
    return 'Stencil $label';
  }

  String _buildStyleLabel(String style, String status) {
    if (style.isEmpty && status.isEmpty) {
      return 'Stencil';
    }
    if (style.isEmpty) {
      return _prettyStatus(status);
    }
    final statusLabel = _prettyStatus(status);
    if (statusLabel.isEmpty) {
      return style;
    }
    return '$style • $statusLabel';
  }

  String _formatDate(String value) {
    final parsed = _parseDate(value);
    if (parsed == null) {
      return 'Unknown date';
    }
    return DateFormat('dd/MM/yyyy').format(parsed.toLocal());
  }

  DateTime? _parseDate(String value) {
    if (value.isEmpty) {
      return null;
    }
    return DateTime.tryParse(value);
  }

  String _prettyStatus(String status) {
    if (status.isEmpty) {
      return '';
    }
    return status
        .split('_')
        .where((part) => part.isNotEmpty)
        .map((part) {
          final lower = part.toLowerCase();
          return '${lower[0].toUpperCase()}${lower.substring(1)}';
        })
        .join(' ');
  }
}
