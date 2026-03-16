import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/moduls/home/controllers/home_controller.dart';
import 'package:cembostyle/moduls/home/presentation/routes/home_routes.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/core/common/widgets/app_ui/quick_action_card.dart';
import 'package:cembostyle/core/common/widgets/app_ui/recent_activity_tile.dart';
import 'package:cembostyle/core/common/widgets/app_ui/section_title.dart';
import 'package:cembostyle/core/common/widgets/app_ui/upload_card.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/home_flow/home_hero_card.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/home_flow/upgrade_plan_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: const NetworkImage(
                    'https://i.pravatar.cc/150?img=56',
                  ),
                  backgroundColor: AppPalette.purpleSoft,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Welcome Back!👋',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppPalette.textSecondary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Iqbal Hasan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(HomeRoutes.pricing),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: AppPalette.purple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Pricing Plan',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            HomeHeroCard(onTryGallery: () => Get.toNamed(HomeRoutes.gallery)),
            const SizedBox(height: 18),
            UploadCard(
              onGalleryTap: () {
                if (!controller.hasActivePlan.value) {
                  showDialog(
                    context: context,
                    builder: (_) => UpgradePlanDialog(
                      onUpgrade: () => Get.toNamed(HomeRoutes.pricing),
                    ),
                  );
                  return;
                }
              },
              onCameraTap: () {
                if (!controller.hasActivePlan.value) {
                  showDialog(
                    context: context,
                    builder: (_) => UpgradePlanDialog(
                      onUpgrade: () => Get.toNamed(HomeRoutes.pricing),
                    ),
                  );
                  return;
                }
              },
            ),
            const SizedBox(height: 18),
            const SectionTitle(title: 'Quick Action', actionText: 'See All'),
            const SizedBox(height: 14),
            Row(
              children: const [
                Expanded(
                  child: QuickActionCard(
                    title: 'My Stencils',
                    icon: Icons.folder_copy_outlined,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: QuickActionCard(
                    title: 'Total Stencil',
                    value: '05',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            const SectionTitle(title: 'Recent Activity'),
            const SizedBox(height: 14),
            Column(
              children: controller.recentActivities
                  .asMap()
                  .entries
                  .map(
                    (entry) => RecentActivityTile(
                      title: entry.value.title,
                      style: entry.value.style,
                      date: entry.value.date,
                      thumbnailUrl: entry.value.thumbnailUrl,
                      highlightStyle: entry.key == 0,
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
