import 'package:flutter_overlay_window/flutter_overlay_window.dart';

class EyeFilter {
  static Future<void> showFilter() async {
    final bool granted = await FlutterOverlayWindow.isPermissionGranted() ?? false;

    if (!granted) {
      final bool requested = await FlutterOverlayWindow.requestPermission() ?? false;
      if (!requested) return;
    }

    await FlutterOverlayWindow.showOverlay(
      height: WindowSize.fullCover,
      width: WindowSize.fullCover,
      alignment: OverlayAlignment.center,
      enableDrag: false,
      overlayTitle: "Eye Comfort Filter",
      overlayContent: "overlayMain",
    );
  }

  static Future<void> closeFilter() async {
    await FlutterOverlayWindow.closeOverlay();
  }
}
