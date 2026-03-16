import 'package:flutter/material.dart';

import 'package:cembostyle/moduls/home/presentation/theme/home_palette.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(
        child: Text(
          'Profile',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: HomePalette.textPrimary,
          ),
        ),
      ),
    );
  }
}
