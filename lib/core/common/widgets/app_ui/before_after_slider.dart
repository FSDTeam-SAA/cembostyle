import 'package:flutter/material.dart';

import 'package:cembostyle/core/common/widgets/app_cached_image.dart';
import 'package:cembostyle/core/theme/app_palette.dart';

class BeforeAfterSlider extends StatelessWidget {
  final String beforeImage;
  final String afterImage;
  final double value;
  final ValueChanged<double> onChanged;

  const BeforeAfterSlider({
    super.key,
    required this.beforeImage,
    required this.afterImage,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        final sliderX = width * value;

        return GestureDetector(
          onHorizontalDragUpdate: (details) {
            final newValue = (details.localPosition.dx / width).clamp(
              0.05,
              0.95,
            );
            onChanged(newValue);
          },
          onTapDown: (details) {
            final newValue = (details.localPosition.dx / width).clamp(
              0.05,
              0.95,
            );
            onChanged(newValue);
          },
          child: Stack(
            children: [
              AppCachedImage(
                imageUrl: afterImage,
                width: width,
                height: height,
                borderRadius: BorderRadius.circular(16),
                onTap: () {},
              ),
              ClipRect(
                child: Align(
                  alignment: Alignment.centerLeft,
                  widthFactor: value,
                  child: AppCachedImage(
                    imageUrl: beforeImage,
                    width: width,
                    height: height,
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {},
                  ),
                ),
              ),
              Positioned(
                left: sliderX - 1,
                top: 12,
                bottom: 12,
                child: Container(width: 2, color: AppPalette.purple),
              ),
              Positioned(
                left: sliderX - 16,
                top: height / 2 - 16,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppPalette.purple, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.compare_arrows,
                    size: 16,
                    color: AppPalette.purple,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
