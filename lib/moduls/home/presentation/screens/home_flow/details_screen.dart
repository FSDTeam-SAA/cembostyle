import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:cembostyle/moduls/home/presentation/controllers/home_controller.dart';
import 'package:cembostyle/moduls/home/presentation/models/home_models.dart';
import 'package:cembostyle/moduls/home/presentation/theme/home_palette.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/common/before_after_slider.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/common/detail_level_slider.dart';
import 'package:cembostyle/moduls/home/presentation/widgets/common/styled_dropdown.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final GalleryItem? item = Get.arguments as GalleryItem?;
    final image = item?.imageUrl ?? controller.galleryItems.first.imageUrl;
    final resultImage =
        item?.resultImageUrl ?? controller.galleryItems.first.resultImageUrl;

    return AppScaffold(
      removePadding: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Details',
          style: TextStyle(color: HomePalette.textPrimary, fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                return DetailLevelSlider(
                  value: controller.selectedDetailLevel.value,
                  onChanged: (value) =>
                      controller.selectedDetailLevel.value = value,
                );
              }),
              const SizedBox(height: 16),
              const Text(
                'Select color theme',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Obx(() {
                final selected = controller
                    .colorThemes[controller.selectedColorThemeIndex.value];
                return StyledDropdown<ColorThemeOption>(
                  value: selected,
                  items: controller.colorThemes
                      .map(
                        (theme) => DropdownMenuItem<ColorThemeOption>(
                          value: theme,
                          child: Text(
                            theme.title,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (newValue) {
                    if (newValue == null) return;
                    final index = controller.colorThemes.indexOf(newValue);
                    controller.selectedColorThemeIndex.value = index;
                  },
                );
              }),
              const SizedBox(height: 16),
              Expanded(
                child: Obx(() {
                  return BeforeAfterSlider(
                    beforeImage: image,
                    afterImage: resultImage,
                    value: controller.compareValue.value,
                    onChanged: controller.updateCompare,
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
