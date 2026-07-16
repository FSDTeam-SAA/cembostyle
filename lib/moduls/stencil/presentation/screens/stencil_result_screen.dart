import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_cached_image.dart';
import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/core/common/widgets/app_ui/before_after_slider.dart';
import 'package:cembostyle/core/common/widgets/app_ui/home_outline_button.dart';
import 'package:cembostyle/core/common/widgets/app_ui/home_primary_button.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/moduls/stencil/controllers/stencil_controller.dart';
import 'package:cembostyle/moduls/stencil/presentation/routes/stencil_routes.dart';

class StencilResultScreen extends StatelessWidget {
  const StencilResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StencilController>();

    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        title: const Text(
          'Your Stencil',
          style: TextStyle(
            color: AppPalette.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Obx(() {
          final record = controller.activeStencil.value;
          final image = record?.originalImageUrl.isNotEmpty == true
              ? record!.originalImageUrl
              : controller.samples.first.originalUrl;
          final resultImage = record?.stencilImageUrl.isNotEmpty == true
              ? record!.stencilImageUrl
              : controller.samples.first.resultUrl;
          final hasFailed = record?.status == 'FAILED';
          final isRealism = record?.style == 'Realism';
          final stencilForOverlay = record?.baseStencilImageUrl.isNotEmpty == true
              ? record!.baseStencilImageUrl
              : resultImage;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Preview and save your creation',
                style: TextStyle(
                  fontSize: 12,
                  color: AppPalette.textSecondary,
                ),
              ),
              const SizedBox(height: 14),
              if (isRealism) ...[
                _OverlayResultView(
                  stencilImageUrl: stencilForOverlay,
                  originalImageUrl: image,
                  selectedColorIndex: controller.selectedColorThemeIndex,
                ),
              ] else ...[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppPalette.cardBorder),
                  ),
                  child: AspectRatio(
                    aspectRatio: 0.94,
                    child: BeforeAfterSlider(
                      beforeImage: image,
                      afterImage: resultImage,
                      value: controller.compareValue.value,
                      onChanged: controller.updateCompare,
                    ),
                  ),
                ),
              ],
              if (hasFailed) ...[
                const SizedBox(height: 14),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF4F4),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFFC5C5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Generation failed',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFB42318),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        record?.errorMessage.isNotEmpty == true
                            ? record!.errorMessage
                            : 'The backend could not generate this stencil.',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppPalette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              HomePrimaryButton(
                text: controller.isSavingToGallery.value
                    ? 'Saving...'
                    : record?.isSaved == true
                    ? 'Saved to gallery'
                    : 'Save to gallery',
                icon: Icon(
                  record?.isSaved == true
                      ? Icons.check_circle_rounded
                      : Icons.save_alt_rounded,
                  size: 18,
                ),
                radius: 28,
                height: 46,
                onTap: controller.isSavingToGallery.value
                    ? null
                    : () => controller.markAsSaved(),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: HomeOutlineButton(
                      text: controller.isDownloading.value
                          ? 'Downloading...'
                          : 'Download',
                      icon: const Icon(Icons.download_rounded, size: 18),
                      borderColor: AppPalette.textPrimary,
                      foregroundColor: AppPalette.textPrimary,
                      fillColor: Colors.white,
                      radius: 26,
                      height: 46,
                      onTap: controller.isDownloading.value
                          ? null
                          : () => _showDownloadSheet(context, controller),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: HomeOutlineButton(
                      text: 'Share',
                      icon: const Icon(Icons.share_rounded, size: 18),
                      borderColor: AppPalette.textPrimary,
                      foregroundColor: AppPalette.textPrimary,
                      fillColor: Colors.white,
                      radius: 26,
                      height: 46,
                      onTap: controller.shareActiveStencil,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Center(
                child: TextButton.icon(
                  onPressed: controller.isGenerating.value
                      ? null
                      : () => Get.offNamed(StencilRoutes.customizeStyle),
                  icon: const Icon(
                    Icons.autorenew_rounded,
                    size: 18,
                    color: AppPalette.purple,
                  ),
                  label: const Text(
                    'Regenerate with new setting',
                    style: TextStyle(
                      color: AppPalette.purple,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void _showDownloadSheet(BuildContext context, StencilController controller) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Download Stencil',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppPalette.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Choose a format',
                style: TextStyle(
                  fontSize: 12,
                  color: AppPalette.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              _DownloadOption(
                icon: Icons.image_outlined,
                title: 'JPG Image',
                subtitle: 'Compressed image format',
                onTap: () {
                  Navigator.pop(context);
                  controller.downloadStencil('jpg');
                },
              ),
              _DownloadOption(
                icon: Icons.image_outlined,
                title: 'PNG Image',
                subtitle: 'Lossless image with transparency',
                onTap: () {
                  Navigator.pop(context);
                  controller.downloadStencil('png');
                },
              ),
              _DownloadOption(
                icon: Icons.picture_as_pdf_outlined,
                title: 'PDF Document',
                subtitle: 'A4 size, ready to print',
                onTap: () {
                  Navigator.pop(context);
                  controller.downloadStencil('pdf');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DownloadOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _DownloadOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppPalette.purpleSoft,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: AppPalette.purple),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppPalette.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppPalette.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: AppPalette.textSecondary),
          ],
        ),
      ),
    );
  }
}

/// Recolors a white-background/dark-ink stencil image to [tint] while
/// leaving white untouched, based on per-pixel luminance. Works regardless
/// of the ink's original hue (the backend may bake in red or black).
List<double> _stencilLineColorMatrix(Color tint) {
  const lr = 0.299, lg = 0.587, lb = 0.114;
  final tr = tint.r * 255;
  final tg = tint.g * 255;
  final tb = tint.b * 255;
  final kr = (255 - tr) / 255;
  final kg = (255 - tg) / 255;
  final kb = (255 - tb) / 255;
  return <double>[
    kr * lr, kr * lg, kr * lb, 0, tr,
    kg * lr, kg * lg, kg * lb, 0, tg,
    kb * lr, kb * lg, kb * lb, 0, tb,
    0, 0, 0, 1, 0,
  ];
}

class _OverlayResultView extends StatelessWidget {
  final String stencilImageUrl;
  final String originalImageUrl;
  final RxInt selectedColorIndex;

  const _OverlayResultView({
    required this.stencilImageUrl,
    required this.originalImageUrl,
    required this.selectedColorIndex,
  });

  static const _overlayColors = [
    Color(0xFF000000),
    Color(0xFFCC0000),
    Color(0xFF1A6B8A),
    Color(0xFF1B7F3A),
  ];

  static const _overlayLabels = ['Black', 'Red', 'Blue', 'Green'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Color',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: AppPalette.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() {
          return Row(
            children: List.generate(_overlayColors.length, (i) {
              final selected = selectedColorIndex.value == i;
              return GestureDetector(
                onTap: () => selectedColorIndex.value = i,
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: selected ? _overlayColors[i] : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _overlayColors[i],
                      width: selected ? 0 : 1.5,
                    ),
                  ),
                  child: Text(
                    _overlayLabels[i],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : _overlayColors[i],
                    ),
                  ),
                ),
              );
            }),
          );
        }),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'Stencil',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppPalette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppPalette.cardBorder),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 0.75,
                        child: Obx(() {
                          final tint = _overlayColors[
                              selectedColorIndex.value.clamp(
                                0,
                                _overlayColors.length - 1,
                              )];
                          return ColorFiltered(
                            colorFilter: ColorFilter.matrix(
                              _stencilLineColorMatrix(tint),
                            ),
                            child: AppCachedImage(
                              imageUrl: stencilImageUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.contain,
                              onTap: () {},
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                children: [
                  const Text(
                    'Overlay Preview',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppPalette.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppPalette.cardBorder),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: AspectRatio(
                        aspectRatio: 0.75,
                        child: Obx(() {
                          final tint = _overlayColors[
                              selectedColorIndex.value.clamp(
                                0,
                                _overlayColors.length - 1,
                              )];
                          return _StencilOverlayView(
                            photoUrl: originalImageUrl,
                            stencilUrl: stencilImageUrl,
                            tint: tint,
                          );
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Composites [stencilUrl] over [photoUrl] using a multiply blend, so the
/// stencil's white background drops out entirely (no dimming/wash-out) and
/// only the ink strokes darken the photo, tinted to [tint].
class _StencilOverlayView extends StatefulWidget {
  final String photoUrl;
  final String stencilUrl;
  final Color tint;

  const _StencilOverlayView({
    required this.photoUrl,
    required this.stencilUrl,
    required this.tint,
  });

  @override
  State<_StencilOverlayView> createState() => _StencilOverlayViewState();
}

class _StencilOverlayViewState extends State<_StencilOverlayView> {
  ui.Image? _photo;
  ui.Image? _stencil;
  ImageStream? _photoStream;
  ImageStream? _stencilStream;
  late final ImageStreamListener _photoListener;
  late final ImageStreamListener _stencilListener;

  @override
  void initState() {
    super.initState();
    _photoListener = ImageStreamListener((info, _) {
      if (mounted) setState(() => _photo = info.image);
    });
    _stencilListener = ImageStreamListener((info, _) {
      if (mounted) setState(() => _stencil = info.image);
    });
    _resolve();
  }

  @override
  void didUpdateWidget(covariant _StencilOverlayView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.photoUrl != widget.photoUrl ||
        oldWidget.stencilUrl != widget.stencilUrl) {
      _photo = null;
      _stencil = null;
      _resolve();
    }
  }

  void _resolve() {
    _photoStream?.removeListener(_photoListener);
    _stencilStream?.removeListener(_stencilListener);

    if (widget.photoUrl.isNotEmpty) {
      _photoStream = CachedNetworkImageProvider(widget.photoUrl)
          .resolve(const ImageConfiguration());
      _photoStream!.addListener(_photoListener);
    }
    if (widget.stencilUrl.isNotEmpty) {
      _stencilStream = CachedNetworkImageProvider(widget.stencilUrl)
          .resolve(const ImageConfiguration());
      _stencilStream!.addListener(_stencilListener);
    }
  }

  @override
  void dispose() {
    _photoStream?.removeListener(_photoListener);
    _stencilStream?.removeListener(_stencilListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ready = _photo != null && _stencil != null;
    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(
          painter: _StencilOverlayPainter(
            photo: _photo,
            stencil: _stencil,
            tint: widget.tint,
          ),
        ),
        if (!ready)
          Container(
            color: Colors.grey.shade200,
            child: const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          ),
      ],
    );
  }
}

class _StencilOverlayPainter extends CustomPainter {
  final ui.Image? photo;
  final ui.Image? stencil;
  final Color tint;

  _StencilOverlayPainter({
    required this.photo,
    required this.stencil,
    required this.tint,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final photo = this.photo;
    if (photo != null) {
      _drawCover(canvas, size, photo, Paint());
    }

    final stencil = this.stencil;
    if (stencil != null) {
      final recolorPaint = Paint()
        ..blendMode = BlendMode.multiply
        ..colorFilter = ColorFilter.matrix(_stencilLineColorMatrix(tint));
      _drawCover(canvas, size, stencil, recolorPaint);
    }
  }

  void _drawCover(Canvas canvas, Size size, ui.Image image, Paint paint) {
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final fitted = applyBoxFit(BoxFit.cover, imageSize, size);
    final srcRect =
        Alignment.center.inscribe(fitted.source, Offset.zero & imageSize);
    final dstRect =
        Alignment.center.inscribe(fitted.destination, Offset.zero & size);
    canvas.drawImageRect(image, srcRect, dstRect, paint);
  }

  @override
  bool shouldRepaint(covariant _StencilOverlayPainter oldDelegate) {
    return oldDelegate.photo != photo ||
        oldDelegate.stencil != stencil ||
        oldDelegate.tint != tint;
  }
}

