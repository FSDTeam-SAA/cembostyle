import 'package:flutter/material.dart';

import 'package:cembostyle/moduls/home/presentation/theme/home_palette.dart';
import 'dashed_border_container.dart';
import 'home_outline_button.dart';

class UploadCard extends StatelessWidget {
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;

  const UploadCard({
    super.key,
    required this.onGalleryTap,
    required this.onCameraTap,
  });

  @override
  Widget build(BuildContext context) {
    return DashedBorderContainer(
      child: Container(
        padding: const EdgeInsets.all(18),
        color: HomePalette.purpleSoft,
        child: Column(
          children: [
            const Icon(Icons.cloud_upload_outlined, color: HomePalette.purple),
            const SizedBox(height: 8),
            const Text(
              'Upload Your own Image',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 4),
            const Text(
              '3 Day free-trial experience',
              style: TextStyle(fontSize: 11, color: HomePalette.textSecondary),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: HomeOutlineButton(
                    text: 'Gallery',
                    icon: const Icon(Icons.photo_library_outlined, size: 16),
                    onTap: onGalleryTap,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: HomeOutlineButton(
                    text: 'Camera',
                    icon: const Icon(Icons.photo_camera_outlined, size: 16),
                    onTap: onCameraTap,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
