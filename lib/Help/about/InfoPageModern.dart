import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class InfoPageModern extends StatefulWidget {
  final String title;
  final List<String> steps;
  final IconData icon;

  const InfoPageModern({
    super.key,
    required this.title,
    required this.steps,
    required this.icon,
  });

  @override
  State<InfoPageModern> createState() => _InfoPageModernState();
}

class _InfoPageModernState extends State<InfoPageModern> {
  late PageController controlPage;

  @override
  void initState() {
    super.initState();
    controlPage = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    controlPage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // HEADER
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // CARD
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.w),
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25.r),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF44a4a4).withOpacity(0.35),
                      blurRadius: 25.r,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: PageView.builder(
                  controller: controlPage,
                  itemCount: widget.steps.length,
                  itemBuilder: (context, index) {
                    return _StepPage(
                      index: index + 1,
                      total: widget.steps.length,
                      title: widget.title,
                      description: widget.steps[index],
                      icon: widget.icon,
                    );
                  },
                ),
              ),
            ),

            SizedBox(height: 15.h),

            // INDICATOR
            SmoothPageIndicator(
              controller: controlPage,
              count: widget.steps.length,
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.black,
                dotColor: Colors.black.withOpacity(0.3),
                dotHeight: 8.h,
                dotWidth: 8.w,
                spacing: 8.w,
                expansionFactor: 3,
              ),
            ),

            SizedBox(height: 25.h),
          ],
        ),
      ),
    );
  }
}

class _StepPage extends StatelessWidget {
  final int index;
  final int total;
  final String title;
  final String description;
  final IconData icon;

  const _StepPage({
    required this.index,
    required this.total,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // 🔥 FIX ROTATION + OVERFLOW
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: const Color(0xFF1FADB6).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 35.sp, color: const Color(0xFF1FADB6)),
            ),

            SizedBox(height: 30.h),

            Text(
              "Pagina $index di $total",
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey,
              ),
            ),

            SizedBox(height: 20.h),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1FADB6),
              ),
            ),

            SizedBox(height: 25.h),

            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),

            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
