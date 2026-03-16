import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/moduls/home/presentation/controllers/home_controller.dart';
import 'package:cembostyle/moduls/home/presentation/routes/home_routes.dart';
import 'package:cembostyle/moduls/home/presentation/theme/home_palette.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/common/quick_action_card.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/common/recent_activity_tile.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/common/section_title.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/common/upload_card.dart';

class StencilTabScreen extends StatelessWidget {
  const StencilTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

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
                color: HomePalette.textPrimary,
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
              onGalleryTap: () => Get.toNamed(HomeRoutes.customizeStyle),
              onCameraTap: () => Get.toNamed(HomeRoutes.customizeStyle),
            ),
            const SizedBox(height: 16),
            const SectionTitle(title: 'Recent Stencil Activity'),
            const SizedBox(height: 12),
            Obx(() {
              return Column(
                children: controller.recentActivities
                    .map((item) => RecentActivityTile(item: item))
                    .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}
