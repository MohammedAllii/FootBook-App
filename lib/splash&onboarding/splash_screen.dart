import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'onboarding_screen.dart';

class PageSplashScreen extends StatefulWidget {
  const PageSplashScreen({super.key});

  @override
  State<PageSplashScreen> createState() => _PageSplashScreenState();
}

class _PageSplashScreenState extends State<PageSplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5), 
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _animationController.forward();

    Future.delayed(const Duration(seconds: 5, milliseconds: 500), () {
      Get.offAll(const OnboardingScreen());
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color:  Colors.white,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Image.asset(
                    'assets/splash.jpg',
                    width: 160 * _animation.value,
                    height: 150 * _animation.value,
                  );
                },
              ),
              const SizedBox(width: 10), 
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "FootBook",
                    style: GoogleFonts.play(
                      color: Colors.black,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        const BoxShadow(
                          color: Color.fromARGB(63, 0, 0, 0),
                          offset: Offset(-3, 3),
                          spreadRadius: 1,
                          blurRadius: 15,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5), 
                  DefaultTextStyle(
                    style: GoogleFonts.antonio(
                      color: Colors.black,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w400,
                      shadows: [
                        const BoxShadow(
                          color: Color.fromARGB(64, 0, 0, 0),
                          offset: Offset(-2, 2),
                          spreadRadius: 1,
                          blurRadius: 11,
                        ),
                      ],
                    ),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      animatedTexts: [
                        TypewriterAnimatedText(
                          "Booking Now",
                          speed: const Duration(milliseconds: 90),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
