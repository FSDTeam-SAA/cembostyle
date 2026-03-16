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

class StencilActivityItem {
  final String id;
  final String title;
  final String style;
  final String date;
  final String thumbnailUrl;

  const StencilActivityItem({
    required this.id,
    required this.title,
    required this.style,
    required this.date,
    required this.thumbnailUrl,
  });
}

class StencilSampleImage {
  final String id;
  final String originalUrl;
  final String resultUrl;

  const StencilSampleImage({
    required this.id,
    required this.originalUrl,
    required this.resultUrl,
  });
}
