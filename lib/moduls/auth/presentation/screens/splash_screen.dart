import 'package:cembostyle/core/common/constants/app_images.dart';
import 'package:cembostyle/core/common/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:cembostyle/moduls/auth/presentation/routes/auth_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        Get.offNamed(AuthRoutes.welcome);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      removePadding: true,
      body: Center(
        child: Image.asset(AppImages.appLogo, width: 193, height: 167),
      ),
    );
  }
}
