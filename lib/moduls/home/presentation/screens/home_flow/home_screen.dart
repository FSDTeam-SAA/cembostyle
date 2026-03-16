import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/moduls/home/presentation/controllers/home_controller.dart';
import 'package:cembostyle/moduls/home/presentation/routes/home_routes.dart';
import 'package:cembostyle/moduls/home/presentation/theme/home_palette.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/common/home_primary_button.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/common/quick_action_card.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/common/recent_activity_tile.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/common/section_title.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/common/upload_card.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/home_flow/home_hero_card.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/home_flow/upgrade_plan_dialog.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: const NetworkImage(
                    'https://i.pravatar.cc/150?img=56',
                  ),
                  backgroundColor: HomePalette.purpleSoft,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 11,
                          color: HomePalette.textSecondary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Iqbal Hasan',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed(HomeRoutes.pricing),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: HomePalette.purple,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Text(
                      'Pricing Plan',
                      style: TextStyle(
                        fontSize: 11,
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
            const SizedBox(height: 16),
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
            const SizedBox(height: 16),
            const SectionTitle(title: 'Quick Action', actionText: 'See All'),
            const SizedBox(height: 12),
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
                    value: '05',
                    icon: Icons.layers_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const SectionTitle(title: 'Recent Activity'),
            const SizedBox(height: 12),
            Obx(() {
              return Column(
                children: controller.recentActivities
                    .map((item) => RecentActivityTile(item: item))
                    .toList(),
              );
            }),
            const SizedBox(height: 6),
            HomePrimaryButton(
              text: 'View All Activity',
              onTap: () {},
              height: 44,
            ),
          ],
        ),
      ),
    );
  }
}
