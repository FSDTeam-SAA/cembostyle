import 'package:get/get.dart';

import '../data/stencil_dummy_data.dart';
import '../models/stencil_models.dart';

class StencilController extends GetxController {
  final RxInt selectedStyleIndex = 0.obs;
  final RxInt selectedColorThemeIndex = 0.obs;
  final RxInt selectedDetailLevel = 1.obs;
  final RxDouble compareValue = 0.55.obs;
  final RxDouble brightness = 0.8.obs;
  final RxDouble contrast = 0.6.obs;

  List<StencilStyleOption> get stencilStyles => StencilDummyData.stencilStyles;
  List<ColorThemeOption> get colorThemes => StencilDummyData.colorThemes;
  List<StencilActivityItem> get recentActivities =>
      StencilDummyData.recentActivities;
  List<StencilSampleImage> get samples => StencilDummyData.samples;

  void updateCompare(double value) {
    compareValue.value = value.clamp(0.05, 0.95);
  }
}
