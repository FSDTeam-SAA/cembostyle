import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_cached_image.dart';
import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/moduls/stencil/controllers/stencil_controller.dart';
import 'package:cembostyle/moduls/stencil/presentation/routes/stencil_routes.dart';
import 'package:cembostyle/core/theme/app_palette.dart';
import 'package:cembostyle/core/common/widgets/app_ui/home_primary_button.dart';
import 'package:cembostyle/moduls/stencil/presentation/widgets/generating_dialog.dart';
import 'package:cembostyle/moduls/stencil/presentation/widgets/style_option_card.dart';

class CustomizeStyleScreen extends StatelessWidget {
  const CustomizeStyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<StencilController>();

    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Customize Style',
          style: TextStyle(color: AppPalette.textPrimary, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose your stencil style and adjust settings',
                style: TextStyle(fontSize: 12, color: AppPalette.textSecondary),
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AppCachedImage(
                  imageUrl: controller.samples.first.originalUrl,
                  height: 240,
                  width: double.infinity,
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                return Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(controller.stencilStyles.length, (
                    index,
                  ) {
                    final item = controller.stencilStyles[index];
                    final selected =
                        controller.selectedStyleIndex.value == index;
                    return SizedBox(
                      width: (MediaQuery.of(context).size.width - 44) / 2,
                      child: StyleOptionCard(
                        title: item.title,
                        subtitle: item.subtitle,
                        isSelected: selected,
                        onTap: () =>
                            controller.selectedStyleIndex.value = index,
                      ),
                    );
                  }),
                );
              }),
              const SizedBox(height: 16),
              const Text(
                'Adjustments',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 12),
              _AdjustmentSlider(
                label: 'Brightness',
                value: controller.brightness,
              ),
              const SizedBox(height: 8),
              _AdjustmentSlider(label: 'Contrast', value: controller.contrast),
              const SizedBox(height: 16),
              HomePrimaryButton(
                text: 'Generate Stencil',
                icon: const Icon(Icons.auto_awesome, size: 16),
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const GeneratingDialog(),
                  );
                  await Future.delayed(const Duration(seconds: 2));
                  Get.back();
                  Get.toNamed(StencilRoutes.stencilResult);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AdjustmentSlider extends StatelessWidget {
  final String label;
  final RxDouble value;

  const _AdjustmentSlider({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: const TextStyle(fontSize: 12)),
              const Spacer(),
              Text(
                '${(value.value * 100).round()}%',
                style: const TextStyle(
                  fontSize: 11,
                  color: AppPalette.textSecondary,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppPalette.purple,
              inactiveTrackColor: AppPalette.divider,
              thumbColor: AppPalette.purple,
              trackHeight: 2,
            ),
            child: Slider(
              value: value.value,
              min: 0,
              max: 1,
              onChanged: (newValue) => value.value = newValue,
            ),
          ),
        ],
      );
    });
  }
}
