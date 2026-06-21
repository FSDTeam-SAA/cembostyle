import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cembostyle/core/common/widgets/app_ui/quick_action_card.dart';
import 'package:cembostyle/core/common/widgets/app_ui/recent_activity_tile.dart';
import 'package:cembostyle/core/common/widgets/app_ui/section_title.dart';
import 'package:cembostyle/core/common/widgets/app_ui/upload_card.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/moduls/home/controllers/home_controller.dart';
import 'package:cembostyle/moduls/home/presentation/routes/home_routes.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/home_flow/home_hero_card.dart';
import 'package:cembostyle/moduls/stencil/controllers/stencil_controller.dart';
import 'package:cembostyle/moduls/stencil/presentation/routes/stencil_routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final stencilController = Get.find<StencilController>();
    controller.ensureLoaded();

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: controller.refreshDashboard,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final profile = controller.profile.value;
                final initials = profile?.initials ?? 'CS';

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: profile != null &&
                              profile.profileImageUrl.isNotEmpty
                          ? NetworkImage(profile.profileImageUrl)
                          : null,
                      backgroundColor: AppPalette.purpleSoft,
                      child: profile == null || profile.profileImageUrl.isEmpty
                          ? Text(
                              initials,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppPalette.purple,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Welcome Back!',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppPalette.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            profile?.name.isNotEmpty == true
                                ? profile!.name
                                : 'Cembostyle Artist',
                            style: const TextStyle(
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
                          color: controller.hasActivePlan.value
                              ? const Color(0xFF14213D)
                              : AppPalette.purple,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          controller.hasActivePlan.value
                              ? 'Premium'
                              : 'Pricing Plan',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              const SizedBox(height: 16),
              HomeHeroCard(onUserGuide: () => _showUserGuide(context)),
              const SizedBox(height: 18),
              UploadCard(
                onGalleryTap: () => _handleUploadFlow(
                  context: context,
                  homeController: controller,
                  stencilController: stencilController,
                  source: ImageSource.gallery,
                ),
                onCameraTap: () => _handleUploadFlow(
                  context: context,
                  homeController: controller,
                  stencilController: stencilController,
                  source: ImageSource.camera,
                ),
              ),
              const SizedBox(height: 18),
              const SectionTitle(title: 'Quick Action', actionText: 'See All'),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: QuickActionCard(
                      title: 'My Stencils',
                      icon: Icons.folder_copy_outlined,
                      onTap: () => Get.toNamed(HomeRoutes.myStencils),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Obx(() {
                      final total = controller.recentActivities.length;
                      return QuickActionCard(
                        title: 'Total Stencil',
                        value: total.toString().padLeft(2, '0'),
                      );
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const SectionTitle(title: 'Recent Activity'),
              const SizedBox(height: 14),
              Obx(() {
                if (controller.isRecentActivityLoading.value &&
                    controller.recentActivities.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final items = controller.recentActivities;
                final hasError = controller.recentActivityError.value.isNotEmpty;

                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            hasError
                                ? controller.recentActivityError.value
                                : 'No recent activity yet.',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppPalette.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextButton(
                            onPressed: controller.refreshRecentActivities,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                final limitedItems = items.take(3).toList();

                return Column(
                  children: [
                    if (hasError)
                      Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppPalette.purple.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text(
                                'Could not refresh activity. Showing last saved data.',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppPalette.textSecondary,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: controller.refreshRecentActivities,
                              child: const Text('Refresh'),
                            ),
                          ],
                        ),
                      ),
                    ...List.generate(limitedItems.length, (index) {
                      final item = limitedItems[index];
                      return RecentActivityTile(
                        title: item.title,
                        style: item.style,
                        date: item.date,
                        thumbnailUrl: item.thumbnailUrl,
                        highlightStyle: index == 0,
                      );
                    }),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _showUserGuide(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'How to Use Bheppo Stencil AI',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _GuideStep(
                number: '1',
                title: 'Upload Your Image',
                description:
                    'Tap Gallery to select a photo or use Camera to take one. Supported formats: JPG, PNG.',
              ),
              _GuideStep(
                number: '2',
                title: 'Choose a Style',
                description:
                    'Outline: clean black lines on white background.\nRealism: detailed red-line tracing with tonal guides.\nPrintHatch: cross-hatch engraving style for printer stencils.\nOverlay Realism: realism stencil shown side-by-side with original.',
              ),
              _GuideStep(
                number: '3',
                title: 'Adjust Brightness & Contrast',
                description:
                    'Use the sliders to fine-tune how dark or detailed your stencil will be.',
              ),
              _GuideStep(
                number: '4',
                title: 'Generate & Save',
                description:
                    'Tap Generate Stencil and wait a few seconds. Save, download, or share your result.',
              ),
              _GuideStep(
                number: '5',
                title: 'Subscription',
                description:
                    'Monthly plan: \$9.99/month. Yearly plan: \$99/year. 3-day free trial available.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleUploadFlow({
    required BuildContext context,
    required HomeController homeController,
    required StencilController stencilController,
    required ImageSource source,
  }) async {
    final picked = await stencilController.pickImage(source);
    if (picked) {
      Get.toNamed(StencilRoutes.customizeStyle);
    }
  }
}

class _GuideStep extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _GuideStep({
    required this.number,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            margin: const EdgeInsets.only(top: 1, right: 10),
            decoration: const BoxDecoration(
              color: AppPalette.purple,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.4,
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
