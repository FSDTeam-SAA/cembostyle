class CategoryItem {
  final String id;
  final String title;

  const CategoryItem({required this.id, required this.title});
}

class GalleryItem {
  final String id;
  final String title;
  final String imageUrl;
  final String resultImageUrl;

  const GalleryItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.resultImageUrl,
  });
}

class ActivityItem {
  final String id;
  final String title;
  final String style;
  final String date;
  final String thumbnailUrl;

  const ActivityItem({
    required this.id,
    required this.title,
    required this.style,
    required this.date,
    required this.thumbnailUrl,
  });
}

class PlanOption {
  final String id;
  final String title;
  final String price;
  final String periodLabel;
  final String badge;
  final String savings;

  const PlanOption({
    required this.id,
    required this.title,
    required this.price,
    required this.periodLabel,
    required this.badge,
    required this.savings,
  });
}

class StencilStyleOption {
  final String id;
  final String title;
  final String subtitle;

  const StencilStyleOption({
    required this.id,
    required this.title,
    required this.subtitle,
  });
}

class ColorThemeOption {
  final String id;
  final String title;

  const ColorThemeOption({required this.id, required this.title});
}
