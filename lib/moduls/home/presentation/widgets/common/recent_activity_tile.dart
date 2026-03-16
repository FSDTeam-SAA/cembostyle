import 'package:flutter/material.dart';

import 'package:cembostyle/core/common/widgets/app_cached_image.dart';
import 'package:cembostyle/moduls/home/presentation/models/home_models.dart';
import 'package:cembostyle/moduls/home/presentation/theme/home_palette.dart';

class RecentActivityTile extends StatelessWidget {
  final ActivityItem item;

  const RecentActivityTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: HomePalette.cardBorder),
      ),
      child: Row(
        children: [
          AppCachedImage(
            imageUrl: item.thumbnailUrl,
            width: 56,
            height: 56,
            borderRadius: BorderRadius.circular(12),
            onTap: () {},
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: HomePalette.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.style,
                  style: const TextStyle(
                    fontSize: 11,
                    color: HomePalette.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item.date,
                  style: const TextStyle(
                    fontSize: 11,
                    color: HomePalette.textMuted,
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
