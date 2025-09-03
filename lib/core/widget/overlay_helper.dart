import 'package:flutter/services.dart';

class OverlayHelper {
  static const MethodChannel _channel = MethodChannel('overlay_channel');

  static Future<void> startOverlay() async {
    await _channel.invokeMethod('startOverlay');
  }

  static Future<void> stopOverlay() async {
    await _channel.invokeMethod('stopOverlay');
  }
}
