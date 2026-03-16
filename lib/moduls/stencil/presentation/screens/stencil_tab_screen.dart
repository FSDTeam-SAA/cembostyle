import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/moduls/stencil/controllers/stencil_controller.dart';
import 'package:cembostyle/moduls/stencil/presentation/routes/stencil_routes.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/core/common/widgets/app_ui/quick_action_card.dart';
import 'package:cembostyle/core/common/widgets/app_ui/recent_activity_tile.dart';
import 'package:cembostyle/core/common/widgets/app_ui/section_title.dart';
import 'package:cembostyle/core/common/widgets/app_ui/upload_card.dart';

class StencilScreen extends StatelessWidget {
  const StencilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StencilController>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Stencil Generator',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppPalette.textPrimary,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: const [
                Expanded(
                  child: QuickActionCard(
                    title: 'My Stencils',
                    value: '03',
                    icon: Icons.folder_copy_outlined,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: QuickActionCard(
                    title: 'Total Stencil',
                    value: '08',
                    icon: Icons.layers_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            UploadCard(
              onGalleryTap: () => Get.toNamed(StencilRoutes.customizeStyle),
              onCameraTap: () => Get.toNamed(StencilRoutes.customizeStyle),
            ),
            const SizedBox(height: 16),
            const SectionTitle(title: 'Recent Stencil Activity'),
            const SizedBox(height: 12),
            Column(
              children: controller.recentActivities
                  .take(3)
                  .map(
                    (item) => RecentActivityTile(
                      title: item.title,
                      style: item.style,
                      date: item.date,
                      thumbnailUrl: item.thumbnailUrl,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
