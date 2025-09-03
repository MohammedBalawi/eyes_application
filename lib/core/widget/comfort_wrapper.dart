
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../features/settings/presentation/controller/settings_controller.dart';

class ComfortWrapper extends StatelessWidget {
  final Widget child;

  const ComfortWrapper({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    final SettingsController settings = Get.find();

    return Obx(() {
      return Stack(
        children: [
          Positioned.fill(child: child),
          Positioned.fill(
            child: IgnorePointer(
              ignoring: true,
              child: Container(
                color: settings.colorWarmthColor
                    .withOpacity(settings.blurAmount.value / 20),
              ),
            ),
          ),
          if (settings.enableBlur.value)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: settings.blurAmount.value,
                    sigmaY: settings.blurAmount.value,
                  ),
                  child: SizedBox.expand(
                    child: Container(color: Colors.transparent),
                  ),
                ),
              ),
            ),
        ],
      );
    });
  }
}
