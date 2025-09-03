
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EyeFilterPlugin {
  static const MethodChannel _channel = MethodChannel('overlay_permission');

  static Future<void> start() async {
    final prefs = await SharedPreferences.getInstance();

    final String warmthStr = prefs.getString("flutter.colorWarmth") ?? "0.5";
    final String opacityStr = prefs.getString("flutter.opacity") ?? "0.0";
    final double warmth = double.tryParse(warmthStr) ?? 0.5;
    final double opacity = double.tryParse(opacityStr) ?? 0.0;

    final double blurAmount = double.tryParse(
          prefs.getString("flutter.blurAmount") ?? "5.0",
        ) ?? 5.0;

    final double focusSharpness = double.tryParse(
          prefs.getString("flutter.focusSharpness") ?? "0.5",
        ) ?? 0.5;

    try {
      await _channel.invokeMethod('startOverlay', {
        "warmth": warmth,
        "opacity": opacity,
        "blurAmount": blurAmount,
        "focusSharpness": focusSharpness,
      });
    } catch (e) {
      print(" Failed to start : \$e");
    }
  }

  static Future<void> stop() async {
    try {
      await _channel.invokeMethod('stopOverlay');
    } catch (e) {
      print(" Failed to stop : \$e");
    }
  }
}
