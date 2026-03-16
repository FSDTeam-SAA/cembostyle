import 'package:get/get.dart';

import '../data/home_dummy_data.dart';
import '../models/home_models.dart';

class HomeController extends GetxController {
  final RxInt bottomNavIndex = 0.obs;
  final RxInt selectedCategoryIndex = 0.obs;
  final RxInt selectedPlanIndex = 0.obs;
  final RxInt selectedColorThemeIndex = 0.obs;
  final RxInt selectedDetailLevel = 1.obs;
  final RxDouble compareValue = 0.55.obs;
  final RxBool hasActivePlan = false.obs;

  List<CategoryItem> get categories => HomeDummyData.categories;
  List<GalleryItem> get galleryItems => HomeDummyData.galleryItems;
  List<ActivityItem> get recentActivities => HomeDummyData.recentActivities;
  List<PlanOption> get plans => HomeDummyData.plans;
  List<ColorThemeOption> get colorThemes => HomeDummyData.colorThemes;

  void setBottomNav(int index) => bottomNavIndex.value = index;

  void setActivePlan(bool value) => hasActivePlan.value = value;

  void updateCompare(double value) {
    compareValue.value = value.clamp(0.05, 0.95);
  }
}
