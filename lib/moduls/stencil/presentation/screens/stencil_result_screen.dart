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
          final hasOverlay = record?.hasOverlay == true;
          final baseStencil = record?.baseStencilImageUrl.isNotEmpty == true
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
              if (hasOverlay) ...[
                _OverlayResultView(
                  stencilImageUrl: baseStencil,
                  overlayImageUrl: resultImage,
                  originalImageUrl: image,
                  selectedColorIndex: controller.selectedColorThemeIndex,
                  colorThemes: controller.colorThemes,
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
                      text: controller.isDownloadingPdf.value
                          ? 'Downloading...'
                          : 'Download',
                      icon: const Icon(Icons.download_rounded, size: 18),
                      borderColor: AppPalette.textPrimary,
                      foregroundColor: AppPalette.textPrimary,
                      fillColor: Colors.white,
                      radius: 26,
                      height: 46,
                      onTap: controller.isDownloadingPdf.value
                          ? null
                          : controller.downloadActiveStencilAsPdf,
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
}

class _OverlayResultView extends StatelessWidget {
  final String stencilImageUrl;
  final String overlayImageUrl;
  final String originalImageUrl;
  final RxInt selectedColorIndex;
  final List<dynamic> colorThemes;

  const _OverlayResultView({
    required this.stencilImageUrl,
    required this.overlayImageUrl,
    required this.originalImageUrl,
    required this.selectedColorIndex,
    required this.colorThemes,
  });

  static const _overlayColors = [
    Color(0xFFCC0000),
    Color(0xFF000000),
    Color(0xFF1A6B8A),
  ];

  static const _overlayLabels = ['Red', 'Black', 'Blue'];

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
                        child: AppCachedImage(
                          imageUrl: stencilImageUrl,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.contain,
                          onTap: () {},
                        ),
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
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              AppCachedImage(
                                imageUrl: originalImageUrl,
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                                onTap: () {},
                              ),
                              ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  tint.withValues(alpha: 0.0),
                                  BlendMode.color,
                                ),
                                child: Opacity(
                                  opacity: 0.72,
                                  child: AppCachedImage(
                                    imageUrl: stencilImageUrl,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    onTap: () {},
                                  ),
                                ),
                              ),
                              ColorFiltered(
                                colorFilter: ColorFilter.mode(
                                  tint.withValues(alpha: 0.45),
                                  BlendMode.srcIn,
                                ),
                                child: Opacity(
                                  opacity: 0.55,
                                  child: AppCachedImage(
                                    imageUrl: stencilImageUrl,
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                    onTap: () {},
                                  ),
                                ),
                              ),
                            ],
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

