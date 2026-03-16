import 'package:flutter/material.dart';

import 'package:cembostyle/moduls/home/presentation/theme/home_palette.dart';

class HomeOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final double height;
  final double? width;
  final Widget? icon;
  final double radius;

  const HomeOutlineButton({
    super.key,
    required this.text,
    this.onTap,
    this.height = 44,
    this.width,
    this.icon,
    this.radius = 24,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: HomePalette.purple,
          side: const BorderSide(color: HomePalette.purple),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, const SizedBox(width: 8)],
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
