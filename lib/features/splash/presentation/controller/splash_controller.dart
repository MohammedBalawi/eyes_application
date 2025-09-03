import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/routes/routes.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void onInit() {
    super.onInit();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animation = CurvedAnimation(parent: controller, curve: Curves.easeIn);

    controller.forward();

    Timer(const Duration(seconds: 3), () => _navigateNext());
  }

  Future<void> _navigateNext() async {
    final prefs = await SharedPreferences.getInstance();
    final bool outBoardingViewed = prefs.getBool('outBoardingViewed') ?? false;

    if (outBoardingViewed) {
      Get.offAllNamed(Routes.home);
    } else {
      Get.offAllNamed(Routes.outboarding);
    }
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
