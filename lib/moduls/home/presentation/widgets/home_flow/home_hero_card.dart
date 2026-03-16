import 'package:flutter/material.dart';

import 'package:cembostyle/core/common/widgets/app_cached_image.dart';
import 'package:cembostyle/moduls/home/presentation/theme/home_palette.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/common/home_primary_button.dart';

class HomeHeroCard extends StatelessWidget {
  final VoidCallback onTryGallery;

  const HomeHeroCard({super.key, required this.onTryGallery});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Stack(
        children: [
          AppCachedImage(
            imageUrl: 'https://picsum.photos/id/1033/900/600',
            height: 150,
            width: double.infinity,
            borderRadius: BorderRadius.circular(18),
            onTap: () {},
          ),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.65),
                  Colors.black.withOpacity(0.2),
                ],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
              ),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Generate Your Own Tattoo Stencil',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Upload any image and convert it into a professional tattoo stencil in seconds.',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  const Spacer(),
                  HomePrimaryButton(
                    text: 'Try the Gallery for free',
                    height: 36,
                    radius: 20,
                    onTap: onTryGallery,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            right: 16,
            bottom: 14,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: HomePalette.purple,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
