import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:footbookcamp/splash&onboarding/splash_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //1) Mettre ici votre clé STRIPE PUBLISHABLE KEY
  Stripe.publishableKey =
      "pk_test_51Sc4LRHLl5lQQENmHkUyRzCGQK6o3OKM7oGYKP6ugXkBGNEdTNPPygGgXuRcwxnrFEWOK0R9BetlZfn9xMB50uIC00Xcw2dhue";

  //2) Initialiser Stripe
  await Stripe.instance.applySettings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: const PageSplashScreen(),
        );
      },
    );
  }
}
