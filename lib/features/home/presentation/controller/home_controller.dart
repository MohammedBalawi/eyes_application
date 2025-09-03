import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/routes/routes.dart';
import '../../../settings/presentation/controller/settings_controller.dart';
import '../model/filter_model.dart';

class HomeController extends GetxController {
  static const platform = MethodChannel('overlay_permission');

  List<FilterModel> predefinedFilters = [
    FilterModel(
      name: ManagerStrings.nightMode,
      temperature: 3200,
      opacity: 0.3,
      focusSharpness: 0.3,
      isDark: true,
    ),
    FilterModel(
      name: ManagerStrings.readingMode,
      temperature: 4400,
      opacity: 0.6,
      focusSharpness: 0.6,
      isDark: false,
    ),
    FilterModel(
      name: ManagerStrings.daylight,
      temperature: 5200,
      opacity: 0.0,
      focusSharpness: 1.0,
      isDark: false,
    ),
  ];

  RxList<FilterModel> customFilters = <FilterModel>[].obs;
  RxString activeFilterName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    requestOverlayPermission();
    deleteCorruptedCustomFilters().then((_) {
      loadCustomFilters();
    });
  }

  Future<void> requestOverlayPermission() async {
    try {
      final result = await platform.invokeMethod('checkPermission');
      debugPrint('Overlay permission result: $result');
      if (result == 'already_granted') {
        await platform.invokeMethod('startOverlay');
      }
    } catch (e) {
      debugPrint('Overlay permission error: $e');
    }
  }

  Future<void> restartOverlay() async {
    try {
      await platform.invokeMethod('startOverlay');
    } catch (e) {
      debugPrint('Overlay restart error: $e');
    }
  }

  Future<void> deleteCorruptedCustomFilters() async {
    final sp = await SharedPreferences.getInstance();
    final keys = sp.getKeys().where((k) => k.startsWith('custom_'));
    for (final key in keys) {
      final value = sp.getString(key);
      try {
        final parsed = jsonDecode(value ?? '');
        if (parsed is! Map<String, dynamic>) throw Exception();
      } catch (e) {
        print(' حذف فلتر غير صالح: $key');
        await sp.remove(key);
      }
    }
    print(' تم حذف الفلاتر التالفة');
  }

  void applyFilter(FilterModel filter) async {
    final settingsController = Get.find<SettingsController>();
    final sp = await SharedPreferences.getInstance();

    final warmth = ((filter.temperature - 3000) / 3000).clamp(0.0, 1.0);
    final blur = (filter.opacity * 20).clamp(0.0, 20.0);

    settingsController.colorWarmth.value = warmth;
    settingsController.updateWarmth(warmth);

    settingsController.focusSharpness.value = filter.focusSharpness;
    settingsController.updateFocusSharpness(filter.focusSharpness);

    if (filter.opacity > 0.0) {
      settingsController.enableBlur.value = true;
      settingsController.blurAmount.value = blur;
      settingsController.updateBlurAmount(blur);
    } else {
      settingsController.enableBlur.value = false;
      settingsController.blurAmount.value = 0.0;
    }

    await sp.setString('flutter.colorWarmth', warmth.toString());
    await sp.setString('flutter.blurAmount', blur.toString());
    await sp.setString('flutter.focusSharpness', filter.focusSharpness.toString());
    await sp.setBool('flutter.enableBlur', filter.opacity > 0.0);

    settingsController.prefs.setDouble(key: 'colorWarmth', value: warmth);
    settingsController.prefs.setDouble(key: 'blurAmount', value: blur);
    settingsController.prefs.setBool(key: 'enableBlur', value: filter.opacity > 0.0);
    settingsController.prefs.setDouble(key: 'focusSharpness', value: filter.focusSharpness);

    activeFilterName.value = filter.name;

    await restartOverlay();
  }

  void applyFilterByName(String name) async {
    final filter = customFilters.firstWhereOrNull((f) => f.name == name);
    if (filter != null) {
      applyFilter(filter);
    }
  }

  void activateFilter(FilterModel filter) {
    final settingsController = Get.find<SettingsController>();
    activeFilterName.value = filter.name;

    if (filter.isCustom) {
      settingsController.loadFilterSettings(filter);
    } else {
      applyFilter(filter);
      Get.toNamed(Routes.settings);
    }
  }

  Future<void> loadCustomFilters() async {
    final sp = await SharedPreferences.getInstance();
    final keys = sp.getKeys().where((k) => k.startsWith('custom_')).toList();
    customFilters.clear();

    for (final key in keys) {
      final value = sp.get(key);
      if (value is String) {
        try {
          final map = jsonDecode(value);
          if (map is Map<String, dynamic>) {
            customFilters.add(
              FilterModel(
                name: map['name'],
                temperature: map['temperature'],
                opacity: (map['opacity'] as num).toDouble(),
                focusSharpness: (map['focusSharpness'] ?? 0.5).toDouble(),
                isCustom: true,
              ),
            );
          }
        } catch (e) {
          print('خطأ في فك الترميز للفلتر $key: $e');
        }
      }
    }

    update();
  }

  void editFilter(FilterModel filter) {
    Get.defaultDialog(
      title: 'Edit "${filter.name}"',
      content: Text('This will open filter editor for ${filter.name}.'),
      textConfirm: 'Save',
      textCancel: 'Cancel',
      onConfirm: () {
        Get.back();
      },
    );
  }

  Future<void> deleteCustomFilter(String name) async {
    final sp = await SharedPreferences.getInstance();
    final key = 'custom_$name';

    final removed = await sp.remove(key);
    if (removed) {
      customFilters.removeWhere((f) => f.name == name);
      update();
      // Get.snackbar('تم الحذف', 'تم حذف الفلتر "$name" بنجاح');
    } else {
      // Get.snackbar('فشل الحذف', 'حدث خطأ أثناء حذف الفلتر "$name"');
    }
  }
}
