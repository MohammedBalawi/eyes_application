import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/resources/manager_width.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/resources/manager_colors.dart';
import '../../../../core/resources/manager_images.dart';
import '../controller/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.put(SplashController());

    return Scaffold(
      backgroundColor: ManagerColors.background,
      body: Center(
        child: FadeTransition(
          opacity: controller.animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 10,
                      offset: Offset(4, 4),
                    ),
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 10,
                      offset: Offset(-4, -4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    ManagerImages.splash,
                    width: ManagerWidth.w180,
                    height: ManagerHeight.h180,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(height: ManagerHeight.h20),
              Text(
                ManagerStrings.eyeFilter,
                style: getBoldTextStyle(
                  fontSize: ManagerFontSize.s28,
                  color: ManagerColors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
