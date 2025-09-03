import 'dart:io' show Platform;
import 'dart:ui';
import 'package:app_mobile/constants/di/dependency_injection.dart';
import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constants/env/env_constants.dart';
import 'core/locale/locales.dart';
import 'core/resources/manager_colors.dart';
import 'core/resources/manager_translation.dart';
import 'core/routes/routes.dart';
import 'core/util/size_util.dart';
import 'core/widget/comfort_wrapper.dart';
import 'features/settings/presentation/controller/settings_controller.dart';

@pragma('vm:entry-point')
void overlayMain() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  final warmthValue =
      double.tryParse(prefs.getString('flutter.colorWarmth') ?? '0.5') ?? 0.5;
  final blurEnabled = prefs.getBool('flutter.enableBlur') ?? false;
  final blurAmount =
      double.tryParse(prefs.getString('flutter.blurAmount') ?? '0.0') ?? 0.0;
  final focusSharpness =
      double.tryParse(prefs.getString('flutter.focusSharpness') ?? '0.5') ??
          0.5;

  Color warmthColor;
  if (warmthValue < 0.5) {
    warmthColor = const Color(0x66FFFFFF);
  } else if (warmthValue < 1.0) {
    warmthColor = const Color(0x66FFF176);
  } else {
    warmthColor = const Color(0xFF5999BF);
  }

  runApp(
    IgnorePointer(
      ignoring: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(
            children: [
              Positioned.fill(child: Container(color: warmthColor)),
              if (blurEnabled && blurAmount > 0)
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: blurAmount,
                      sigmaY: blurAmount * (1 - focusSharpness),
                    ),
                    child: Container(),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> _maybeShowOverlayOnAndroid() async {
  if (kIsWeb || !Platform.isAndroid) return;

  final prefs = await SharedPreferences.getInstance();
  final overlayEnabled = prefs.getBool('flutter.enableBlur') ?? false;

  if (!overlayEnabled) return;

  final granted = await FlutterOverlayWindow.isPermissionGranted() ?? false;

  if (granted) {
    await FlutterOverlayWindow.showOverlay(
      height: WindowSize.fullCover,
      width: WindowSize.fullCover,
      alignment: OverlayAlignment.center,
      enableDrag: false,
      overlayTitle: 'Eye Comfort Filter',
      overlayContent: 'overlayMain',
      flag: OverlayFlag.clickThrough,
    );
  } else {
    final requested = await FlutterOverlayWindow.requestPermission() ?? false;
    if (!requested) {
      debugPrint('Overlay permission was not granted.');
    }
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initModule();

  await _maybeShowOverlayOnAndroid();

  runApp(
    EasyLocalization(
      supportedLocales: localeSettings.locales,
      path: translationPath,
      fallbackLocale: localeSettings.defaultLocale,
      startLocale: localeSettings.defaultLocale,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final SettingsController settings = Get.find();

    return Obx(
      () => GetMaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        debugShowCheckedModeBanner: false,
        defaultGlobalState: dotenv.env[EnvConstants.debug].onNullBool(),
        onGenerateRoute: RouteGenerator.getRoute,
        initialRoute: Routes.splash,
        theme: ThemeData(
          useMaterial3: true,
          brightness:
              settings.isDark.value ? Brightness.dark : Brightness.light,
          scaffoldBackgroundColor: settings.isDark.value
              ? Colors.grey.shade900
              : ManagerColors.white,
          colorScheme: ColorScheme.fromSeed(
            seedColor: settings.colorWarmth.value < 0.5
                ? Colors.blueAccent
                : settings.colorWarmth.value < 1.0
                    ? Colors.yellow
                    : Colors.deepOrange,
            brightness:
                settings.isDark.value ? Brightness.dark : Brightness.light,
          ),
        ),
        builder: (context, child) => ComfortWrapper(child: child!),
      ),
    );
  }
}
