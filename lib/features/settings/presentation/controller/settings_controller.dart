// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../../../../core/routes/routes.dart';
// import '../../../../core/storage/local/app_settings_prefs.dart';
// import '../../../../core/widget/eye_filter_plugin.dart';
// import '../../../home/presentation/controller/home_controller.dart';
// import '../../../home/presentation/model/filter_model.dart';
//
// class SettingsController extends GetxController {
//   final TextEditingController filterNameController = TextEditingController();
//
//   RxBool isDark = false.obs;
//   RxDouble colorWarmth = 0.5.obs;
//   RxDouble blurAmount = 5.0.obs;
//   RxString contrastMode = 'light'.obs;
//   RxDouble focusSharpness = 0.5.obs;
//   RxBool enableBlur = false.obs;
//   RxString warmthLevel = 'normal'.obs;
//
//   late AppSettingsPrefs prefs;
//   Rx<Locale> currentLocale = const Locale('en').obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadPrefs();
//   }
//
//   Future<void> loadPrefs() async {
//     final sp = await SharedPreferences.getInstance();
//     prefs = AppSettingsPrefs(sp);
//
//     isDark.value = await prefs.getBool(key: 'isDark') ?? false;
//     colorWarmth.value = await prefs.getDouble(key: 'colorWarmth') ?? 0.5;
//     blurAmount.value = await prefs.getDouble(key: 'blurAmount') ?? 5.0;
//     focusSharpness.value = await prefs.getDouble(key: 'focusSharpness') ?? 0.5;
//     contrastMode.value = await prefs.getString(key: 'contrastMode') ?? 'light';
//     warmthLevel.value = await prefs.getString(key: 'warmthLevel') ?? 'normal';
//     enableBlur.value = await prefs.getBool(key: 'enableBlur') ?? false;
//
//     final lang = await prefs.getString(key: 'languageCode');
//     if (lang != null) {
//       currentLocale.value = Locale(lang);
//       Get.updateLocale(currentLocale.value);
//     }
//
//     final sharedPrefs = await SharedPreferences.getInstance();
//     sharedPrefs.setString("flutter.colorWarmth", colorWarmth.value.toString());
//     sharedPrefs.setString(
//         "flutter.opacity",
//         (enableBlur.value
//             ? (blurAmount.value / 20).clamp(0.0, 1.0).toString()
//             : "0.0"));
//     sharedPrefs.setBool("flutter.enableBlur", enableBlur.value);
//
//   }
//
//   void toggleDarkMode(bool value) {
//     isDark.value = value;
//     prefs.setBool(key: 'isDark', value: value);
//   }
//
//   void updateFocusSharpness(double value) {
//     focusSharpness.value = value;
//     prefs.setDouble(key: 'focusSharpness', value: value);
//   }
//
//   Future<void> applyFilterAndRestartOverlay({
//     required double warmth,
//     required double blur,
//     required double focus,
//   }) async {
//     final prefs = await SharedPreferences.getInstance();
//
//     await prefs.setString("flutter.colorWarmth", warmth.toString());
//     await prefs.setString("flutter.blurAmount", blur.toString());
//     await prefs.setString("flutter.focusSharpness", focus.toString());
//
//     const platform = MethodChannel('overlay_channel');
//     try {
//       await platform.invokeMethod('stopOverlay');
//     } catch (_) {}
//
//     try {
//       await platform.invokeMethod('startOverlay');
//     } catch (e) {
//       print(' خطأ عند تشغيل overlay: $e');
//     }
//   }
//
//   void setWarmthLevel(String level) {
//     warmthLevel.value = level;
//
//     switch (level) {
//       case 'normal':
//         colorWarmth.value = 0.2;
//         break;
//       case 'medium':
//         colorWarmth.value = 0.6;
//         break;
//       case 'advanced':
//         colorWarmth.value = 0.9;
//         break;
//     }
//
//     prefs.setString(key: 'warmthLevel', value: level);
//     prefs.setDouble(key: 'colorWarmth', value: colorWarmth.value);
//
//     SharedPreferences.getInstance().then((sp) {
//       sp.setString("flutter.colorWarmth", colorWarmth.value.toString());
//     });
//   }
//
//   void updateWarmth(double value) {
//     colorWarmth.value = value;
//     prefs.setDouble(key: 'colorWarmth', value: value);
//     SharedPreferences.getInstance().then((sp) {
//       sp.setString("flutter.colorWarmth", value.toString());
//     });
//   }
//
//   void setContrastMode(String mode) {
//     contrastMode.value = mode;
//     prefs.setString(key: 'contrastMode', value: mode);
//   }
//
//   void changeLanguage(Locale locale) {
//     currentLocale.value = locale;
//     Get.updateLocale(locale);
//     prefs.setString(key: 'languageCode', value: locale.languageCode);
//   }
//
//   Future<void> saveCustomFilter() async {
//     final name = filterNameController.text.trim();
//     if (name.isEmpty) return;
//
//     final int temperature = (colorWarmth.value * 3000 + 3000).toInt();
//     final double opacity =
//         (enableBlur.value ? blurAmount.value / 20 : 0.0).clamp(0.0, 1.0);
//
//     final filter = FilterModel(
//       name: name,
//       temperature: temperature,
//       opacity: opacity,
//       focusSharpness: focusSharpness.value,
//       isDark: isDark.value,
//       isCustom: true,
//     );
//
//     await prefs.setString(key: 'custom_$name', value: filter.toJsonString());
//     filterNameController.clear();
//
//     Get.snackbar('نجاح', 'تم حفظ الوضع المخصص');
//
//     final homeController = Get.find<HomeController>();
//     await homeController.loadCustomFilters();
//
//     Get.offAllNamed(Routes.home);
//   }
//
//   Future<void> loadFilterSettings(FilterModel filter) async {
//     final name = filter.name.trim();
//     final key = 'custom_$name';
//     final json = await prefs.getString(key: key);
//
//     if (json == null || json.isEmpty) {
//       Get.snackbar('تنبيه', 'لا توجد إعدادات محفوظة لهذا الوضع. أعد إنشاءها.');
//       return;
//     }
//
//     try {
//       final data = FilterModel.fromJsonString(json);
//
//       colorWarmth.value = ((data.temperature - 3000) / 3000).clamp(0.0, 1.0);
//       blurAmount.value = (data.opacity * 20).clamp(0.0, 20.0);
//       enableBlur.value = data.opacity > 0.0;
//       focusSharpness.value = data.focusSharpness;
//       isDark.value = data.isDark;
//
//       prefs.setDouble(key: 'colorWarmth', value: colorWarmth.value);
//       prefs.setDouble(key: 'blurAmount', value: blurAmount.value);
//       prefs.setBool(key: 'enableBlur', value: enableBlur.value);
//       prefs.setBool(key: 'isDark', value: isDark.value);
//
//       SharedPreferences.getInstance().then((sp) {
//         sp.setString("flutter.colorWarmth", colorWarmth.value.toString());
//         sp.setString(
//             "flutter.opacity",
//             (enableBlur.value
//                 ? (blurAmount.value / 20).clamp(0.0, 1.0).toString()
//                 : "0.0"));
//         sp.setBool("flutter.enableBlur", enableBlur.value);
//       });
//
//       filterNameController.text = name;
//
//       Get.toNamed(Routes.settings);
//     } catch (e) {
//       Get.snackbar('خطأ', 'فشل في تحميل الإعدادات: $e');
//     }
//   }
//
//   Color get colorWarmthColor {
//     if (colorWarmth.value < 0.5) return Colors.white;
//     if (colorWarmth.value < 1.0) return Colors.yellow;
//     return Color(0xFF5999BF);
//   }
//   final List<Map<String, double>> blurFocusLevels = [
//     {'blur': 1.0, 'focus': 1.1},
//     {'blur': 2.5, 'focus': 2.2},
//     {'blur': 4.0, 'focus': 3.3},
//     {'blur': 6.0, 'focus': 4.4},
//     {'blur': 8.0, 'focus': 5.5},
//     {'blur': 10.0, 'focus': 5.6},
//     {'blur': 13.0, 'focus': 7.7},
//     {'blur': 16.0, 'focus': 8.8},
//     {'blur': 20.0, 'focus': 9.9},
//   ];
//
//
//   Future<void> updateOverlay() async {
//     const platform = MethodChannel('overlay_permission');
//     try {
//       await platform.invokeMethod('startOverlay');
//     } catch (e) {
//       debugPrint('Overlay update error: $e');
//     }
//   }
//
//   void toggleBlur(bool value) {
//     enableBlur.value = value;
//     if (!value) blurAmount.value = 0;
//     prefs.setBool(key: 'enableBlur', value: value);
//     SharedPreferences.getInstance().then((sp) {
//       sp.setBool("flutter.enableBlur", value);
//       sp.setString("flutter.opacity",
//           (value ? (blurAmount.value / 20).clamp(0.0, 1.0).toString() : "0.0"));
//     });
//     updateOverlay();
//   }
//   // void activateGlobalFilter() async {
//   //   await EyeFilterPlugin.start();
//   // }
//   //
//   // void deactivateGlobalFilter() async {
//   //   await EyeFilterPlugin.stop();
//   // }
//
//   void updateBlurAmount(double value) {
//     blurAmount.value = value;
//     prefs.setDouble(key: 'blurAmount', value: value);
//     SharedPreferences.getInstance().then((sp) {
//       sp.setString("flutter.opacity",
//           (enableBlur.value ? (value / 20).clamp(0.0, 1.0).toString() : "0.0"));
//     });
//     updateOverlay();
//   }
//
//   @override
//   void onClose() {
//     filterNameController.dispose();
//     super.onClose();
//   }
// }
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:screen_brightness/screen_brightness.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/routes/routes.dart';
import '../../../../core/storage/local/app_settings_prefs.dart';
import '../../../home/presentation/controller/home_controller.dart';
import '../../../home/presentation/model/filter_model.dart';

class SettingsController extends GetxController {
  final TextEditingController filterNameController = TextEditingController();
  RxDouble screenBrightness = 0.1.obs;
  RxBool isDark = false.obs;
  RxDouble colorWarmth = 0.5.obs;
  RxDouble blurAmount = .1.obs;
  RxString contrastMode = 'light'.obs;
  RxDouble focusSharpness = 0.5.obs;
  RxBool enableBlur = false.obs;
  RxString warmthLevel = 'normal'.obs;

  late AppSettingsPrefs prefs;
  Rx<Locale> currentLocale = const Locale('en').obs;

  final List<Map<String, double>> blurFocusLevels = [
    {'blur': 0.1, 'focus': 0.1},
    {'blur': 0.12, 'focus': 0.12},
    {'blur': 0.13, 'focus': 0.13},
    {'blur': 0.14, 'focus': 0.14},
    {'blur': 0.5, 'focus': 0.5},
    {'blur': 0.56, 'focus': 0.56},
    {'blur': 0.97, 'focus': 0.97},
    {'blur': 1.58, 'focus': 1.58},
    {'blur': 2.0, 'focus': 2.0},
  ];

  @override
  void onInit() {
    super.onInit();
    loadPrefs();
    // loadBrightness();
  }

  // Future<void> loadBrightness() async {
  //   try {
  //     double brightness = await ScreenBrightness().current;
  //     screenBrightness.value = brightness;
  //   } catch (e) {
  //     debugPrint('Error loading brightness: $e');
  //   }
  // }
  // Future<void> updateBrightness(double value) async {
  //   try {
  //     screenBrightness.value = value.clamp(0.0, 1.0);
  //     await ScreenBrightness().setScreenBrightness(screenBrightness.value);
  //     prefs.setDouble(key: 'screenBrightness', value: screenBrightness.value);
  //   } catch (e) {
  //     debugPrint('Error setting brightness: $e');
  //   }
  // }

  Future<void> loadPrefs() async {
    final sp = await SharedPreferences.getInstance();
    prefs = AppSettingsPrefs(sp);

    isDark.value = await prefs.getBool(key: 'isDark') ?? false;
    colorWarmth.value = await prefs.getDouble(key: 'colorWarmth') ?? 0.5;
    blurAmount.value = await prefs.getDouble(key: 'blurAmount') ?? 0.5;
    focusSharpness.value = await prefs.getDouble(key: 'focusSharpness') ?? 0.5;
    contrastMode.value = await prefs.getString(key: 'contrastMode') ?? 'light';
    warmthLevel.value = await prefs.getString(key: 'warmthLevel') ?? 'normal';
    enableBlur.value = await prefs.getBool(key: 'enableBlur') ?? false;

    final lang = await prefs.getString(key: 'languageCode');
    if (lang != null) {
      currentLocale.value = Locale(lang);
      Get.updateLocale(currentLocale.value);
    }

    sp.setString("flutter.colorWarmth", colorWarmth.value.toString());
    sp.setString("flutter.blurAmount", blurAmount.value.toString());
    sp.setString("flutter.focusSharpness", focusSharpness.value.toString());
    sp.setBool("flutter.enableBlur", enableBlur.value);
  }

  void toggleDarkMode(bool value) {
    isDark.value = value;
    prefs.setBool(key: 'isDark', value: value);
  }

  void updateFocusSharpness(double value) {
    focusSharpness.value = value;
    prefs.setDouble(key: 'focusSharpness', value: value);
    SharedPreferences.getInstance().then((sp) {
      sp.setString("flutter.focusSharpness", value.toString());
    });
    updateOverlay();
  }

  Future<void> applyFilterAndRestartOverlay({
    required double warmth,
    required double blur,
    required double focus,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("flutter.colorWarmth", warmth.toString());
    await prefs.setString("flutter.blurAmount", blur.toString());
    await prefs.setString("flutter.focusSharpness", focus.toString());
    await prefs.setBool("flutter.enableBlur", true);

    const platform = MethodChannel('overlay_channel');
    try {
      await platform.invokeMethod('stopOverlay');
    } catch (_) {}

    try {
      await platform.invokeMethod('startOverlay');
    } catch (e) {
      print(' خطأ عند تشغيل overlay: $e');
    }
  }

  void setWarmthLevel(String level) {
    warmthLevel.value = level;

    switch (level) {
      case 'normal':
        colorWarmth.value = 0.2;
        break;
      case 'medium':
        colorWarmth.value = 0.6;
        break;
      case 'advanced':
        colorWarmth.value = 0.9;
        break;
    }

    prefs.setString(key: 'warmthLevel', value: level);
    prefs.setDouble(key: 'colorWarmth', value: colorWarmth.value);

    SharedPreferences.getInstance().then((sp) {
      sp.setString("flutter.colorWarmth", colorWarmth.value.toString());
    });
  }

  void updateWarmth(double value) {
    colorWarmth.value = value;
    prefs.setDouble(key: 'colorWarmth', value: value);
    SharedPreferences.getInstance().then((sp) {
      sp.setString("flutter.colorWarmth", value.toString());
    });
    updateOverlay();
  }

  void setContrastMode(String mode) {
    contrastMode.value = mode;
    prefs.setString(key: 'contrastMode', value: mode);
  }

  // void changeLanguage(Locale locale) {
  //   currentLocale.value = locale;
  //   Get.updateLocale(locale);
  //   prefs.setString(key: 'languageCode', value: locale.languageCode);
  // }
  void changeLanguage(Locale locale, BuildContext context) {
    currentLocale.value = locale;
    Get.updateLocale(locale);
    prefs.setString(key: 'languageCode', value: locale.languageCode);
    context.setLocale(locale);
  }

  Future<void> saveCustomFilter() async {
    final name = filterNameController.text.trim();
    if (name.isEmpty) return;

    final int temperature = (colorWarmth.value * 3000 + 3000).toInt();
    final double opacity =
    (enableBlur.value ? blurAmount.value /1 : 0.0).clamp(0.0, 1.0);

    final filter = FilterModel(
      name: name,
      temperature: temperature,
      opacity: opacity,
      focusSharpness: focusSharpness.value,
      isDark: isDark.value,
      isCustom: true,
    );

    await prefs.setString(key: 'custom_$name', value: filter.toJsonString());
    filterNameController.clear();

    Get.snackbar(ManagerStrings.success, ManagerStrings.save);

    final homeController = Get.find<HomeController>();
    await homeController.loadCustomFilters();

    Get.offAllNamed(Routes.home);
  }

  Future<void> loadFilterSettings(FilterModel filter) async {
    final name = filter.name.trim();
    final key = 'custom_$name';
    final json = await prefs.getString(key: key);

    if (json == null || json.isEmpty) {
      return;
    }

    try {
      final data = FilterModel.fromJsonString(json);

      colorWarmth.value = ((data.temperature - 3000) / 3000).clamp(0.0, 1.0);
      blurAmount.value = (data.opacity * 1).clamp(0.0, 1.0);
      enableBlur.value = data.opacity > 0.0;
      focusSharpness.value = data.focusSharpness;
      isDark.value = data.isDark;

      prefs.setDouble(key: 'colorWarmth', value: colorWarmth.value);
      prefs.setDouble(key: 'blurAmount', value: blurAmount.value);
      prefs.setBool(key: 'enableBlur', value: enableBlur.value);
      prefs.setBool(key: 'isDark', value: isDark.value);

      SharedPreferences.getInstance().then((sp) {
        sp.setString("flutter.colorWarmth", colorWarmth.value.toString());
        sp.setString("flutter.blurAmount", blurAmount.value.toString());
        sp.setString("flutter.focusSharpness", focusSharpness.value.toString());
        sp.setBool("flutter.enableBlur", enableBlur.value);
      });

      filterNameController.text = name;
      Get.toNamed(Routes.settings);
    } catch (e) {
    }
  }

  Color get colorWarmthColor {
    if (colorWarmth.value < 0.5) return Colors.white;
    if (colorWarmth.value < 1.0) return Colors.yellow;
    return const Color(0xFF5999BF);
  }

  Future<void> updateOverlay() async {
    const platform = MethodChannel('overlay_permission');
    try {
      await platform.invokeMethod('startOverlay');
    } catch (e) {
      debugPrint('Overlay update error: $e');
    }
  }

  void toggleBlur(bool value) {
    enableBlur.value = value;
    if (!value) blurAmount.value = 0;
    prefs.setBool(key: 'enableBlur', value: value);
    SharedPreferences.getInstance().then((sp) {
      sp.setBool("flutter.enableBlur", value);
      sp.setString("flutter.blurAmount", blurAmount.value.toString());
    });
    updateOverlay();
  }

  void updateBlurAmount(double value) {
    blurAmount.value = value;
    prefs.setDouble(key: 'blurAmount', value: value);
    SharedPreferences.getInstance().then((sp) {
      sp.setString("flutter.blurAmount", value.toString());
    });
    updateOverlay();
  }

  @override
  void onClose() {
    filterNameController.dispose();
    super.onClose();
  }
}
