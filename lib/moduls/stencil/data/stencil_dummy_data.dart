import '../models/stencil_models.dart';

class StencilDummyData {
  static const List<StencilStyleOption> stencilStyles = [
    StencilStyleOption(
      id: 'outline',
      title: 'Outline',
      subtitle: 'Clean transfer lines',
    ),
    StencilStyleOption(
      id: 'realism',
      title: 'Realism',
      subtitle: 'Stencil + overlay preview',
    ),
    StencilStyleOption(
      id: 'printhatch',
      title: 'PrintHatch',
      subtitle: 'For stencils from printers',
    ),
  ];

  static const List<ColorThemeOption> colorThemes = [
    ColorThemeOption(id: 'black', title: 'Black'),
    ColorThemeOption(id: 'red', title: 'Red'),
    ColorThemeOption(id: 'blue', title: 'Blue'),
    ColorThemeOption(id: 'green', title: 'Green'),
  ];

  static const List<StencilActivityItem> recentActivities = [
    StencilActivityItem(
      id: 's1',
      title: 'Stenciled a dragon tattoo',
      style: 'Impressionist',
      date: '27/02/2026',
      thumbnailUrl: 'https://picsum.photos/id/1025/200/240',
    ),
    StencilActivityItem(
      id: 's2',
      title: 'Stenciled a dragon tattoo',
      style: 'Impressionist',
      date: '27/02/2026',
      thumbnailUrl: 'https://picsum.photos/id/1005/200/240',
    ),
    StencilActivityItem(
      id: 's3',
      title: 'Stenciled a dragon tattoo',
      style: 'Impressionist',
      date: '27/02/2026',
      thumbnailUrl: 'https://picsum.photos/id/1000/200/240',
    ),
  ];

  static const List<StencilSampleImage> samples = [
    StencilSampleImage(
      id: 'sample1',
      originalUrl: 'https://picsum.photos/id/1062/700/700',
      resultUrl: 'https://picsum.photos/id/1050/700/700',
    ),
  ];
}
