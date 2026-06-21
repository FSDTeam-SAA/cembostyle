import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:cembostyle/core/common/widgets/app_cached_image.dart';
import 'package:cembostyle/core/theme/app_palette.dart';

class RecentActivityTile extends StatelessWidget {
  final String title;
  final String style;
  final String date;
  final String thumbnailUrl;
  final String originalImageUrl;
  final bool highlightStyle;
  final bool splitPreview;

  const RecentActivityTile({
    super.key,
    required this.title,
    required this.style,
    required this.date,
    required this.thumbnailUrl,
    this.originalImageUrl = '',
    this.highlightStyle = false,
    this.splitPreview = true,
  });

  @override
  Widget build(BuildContext context) {
    const previewSize = 86.0;
    const previewRadius = 12.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppPalette.cardBorder, width: 1.2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: previewSize,
            height: previewSize,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(previewRadius),
              border: Border.all(color: AppPalette.cardBorder),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(previewRadius - 2),
              child: splitPreview && originalImageUrl.isNotEmpty
                  ? _SplitPreview(
                      originalUrl: originalImageUrl,
                      stencilUrl: thumbnailUrl,
                      size: previewSize,
                    )
                  : AppCachedImage(
                      imageUrl: thumbnailUrl,
                      width: previewSize,
                      height: previewSize,
                      fit: BoxFit.cover,
                      onTap: () {},
                    ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: AppPalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  style,
                  style: TextStyle(
                    fontSize: 15,
                    color: highlightStyle
                        ? AppPalette.textSecondary
                        : AppPalette.textSecondary,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppPalette.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SplitPreview extends StatelessWidget {
  final String originalUrl;
  final String stencilUrl;
  final double size;

  const _SplitPreview({
    required this.originalUrl,
    required this.stencilUrl,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _SplitImagePainter(),
        child: Stack(
          children: [
            Positioned.fill(
              child: _buildHalf(originalUrl, Alignment.centerLeft),
            ),
            Positioned(
              left: size / 2,
              top: 0,
              right: 0,
              bottom: 0,
              child: _buildHalf(stencilUrl, Alignment.centerRight),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHalf(String url, Alignment alignment) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      alignment: alignment,
      placeholder: (context, url) => Container(color: Colors.grey.shade200),
      errorWidget: (context, url, error) => Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.error, color: Colors.red, size: 20),
      ),
    );
  }
}

class _SplitImagePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {}

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
