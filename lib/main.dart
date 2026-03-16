import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:cembostyle/auth/presentation/routes/auth_routes.dart';
import 'package:cembostyle/auth/presentation/screens/email_verification_screen.dart';
import 'package:cembostyle/auth/presentation/screens/lets_you_in_screen.dart';
import 'package:cembostyle/auth/presentation/screens/login_screen.dart';
import 'package:cembostyle/auth/presentation/screens/otp_verification_screen.dart';
import 'package:cembostyle/auth/presentation/screens/reset_password_screen.dart';
import 'package:cembostyle/auth/presentation/screens/signup_screen.dart';
import 'package:cembostyle/auth/presentation/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.poppinsTextTheme(),
        useMaterial3: false,
      ),
      initialRoute: AuthRoutes.splash,
      getPages: [
        GetPage(name: AuthRoutes.splash, page: () => const SplashScreen()),
        GetPage(name: AuthRoutes.welcome, page: () => const LetsYouInScreen()),
        GetPage(name: AuthRoutes.signup, page: () => const SignUpScreen()),
        GetPage(name: AuthRoutes.login, page: () => const LoginScreen()),
        GetPage(
          name: AuthRoutes.emailVerification,
          page: () => const EmailVerificationScreen(),
        ),
        GetPage(
          name: AuthRoutes.otp,
          page: () => const OtpVerificationScreen(),
        ),
        GetPage(
          name: AuthRoutes.resetPassword,
          page: () => const ResetPasswordScreen(),
        ),
      ],
    );
  }
}
