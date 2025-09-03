import 'package:app_mobile/core/locale/locales.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui';
import '../../../../core/widget/text_field.dart';
import '../../../privacy_policy/presentation/View/privacy_policy_view.dart';
import '../controller/settings_controller.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  Color getDarkTextColor(bool isDarkMode, double focusSharpness) {
    if (isDarkMode) {
      return Color.lerp(Colors.grey[400], ManagerColors.white, focusSharpness)!;
    } else {
      return Color.lerp(Colors.grey[500], ManagerColors.black, focusSharpness)!;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Obx(() => Text(
          ManagerStrings.comfortSettings,
          style: getMediumTextStyle(
            color: getDarkTextColor(
                controller.isDark.value, controller.focusSharpness.value),
            fontSize: ManagerFontSize.s14,
          ),
        )),
      ),
      body: Obx(() => Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                SwitchListTile(
                  value: controller.isDark.value,
                  onChanged: controller.toggleDarkMode,
                  title: Text(
                    ManagerStrings.darkMode,
                    style: getRegularTextStyle(
                      color: getDarkTextColor(controller.isDark.value,
                          controller.focusSharpness.value),
                      fontSize: ManagerFontSize.s12,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  ManagerStrings.screenWarmth,
                  style: getMediumTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: getDarkTextColor(controller.isDark.value,
                        controller.focusSharpness.value),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => controller.setWarmthLevel('normal'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        controller.warmthLevel.value == 'normal'
                            ? Colors.grey
                            : Colors.grey[300],
                        foregroundColor: getDarkTextColor(
                            controller.isDark.value,
                            controller.focusSharpness.value),
                      ),
                      child: Text(ManagerStrings.warmthNormal),
                    ),
                    ElevatedButton(
                      onPressed: () => controller.setWarmthLevel('medium'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        controller.warmthLevel.value == 'medium'
                            ? Colors.amber[400]
                            : Colors.grey[300],
                        foregroundColor: getDarkTextColor(
                            controller.isDark.value,
                            controller.focusSharpness.value),
                      ),
                      child: Text(ManagerStrings.warmthMedium),
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          controller.setWarmthLevel('advanced'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        controller.warmthLevel.value == 'advanced'
                            ? Color(0x6654CAF4)
                            : Colors.grey[300],
                        foregroundColor: getDarkTextColor(
                            controller.isDark.value,
                            controller.focusSharpness.value),
                      ),
                      child: Text(ManagerStrings.warmthAdvanced),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 24),
                const SizedBox(height: 24),
                Text(
                  ManagerStrings.enableBlur,
                  style: getBoldTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: getDarkTextColor(controller.isDark.value,
                        controller.focusSharpness.value),
                  ),
                ),
                SwitchListTile(
                  value: controller.enableBlur.value,
                  onChanged: controller.toggleBlur,
                  title: Text(
                    ManagerStrings.focusBlur,
                    style: getMediumTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: getDarkTextColor(controller.isDark.value,
                          controller.focusSharpness.value),
                    ),
                  ),
                ),
                if (controller.enableBlur.value) ...[
                  const SizedBox(height: 16),
                  Text(
                    ManagerStrings.blurIntensity,
                    style: getMediumTextStyle(
                      fontSize: ManagerFontSize.s16,
                      color: getDarkTextColor(controller.isDark.value,
                          controller.focusSharpness.value),
                    ),
                  ),
                  Slider(
                    value: controller.blurAmount.value,
                    min: 0.0,
                    max: 2.0,
                    divisions: 10,
                    label: controller.blurAmount.value.toStringAsFixed(1),
                    onChanged: controller.updateBlurAmount,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    ManagerStrings.quickFocusBlurLevels,
                    style: getMediumTextStyle(
                      fontSize: ManagerFontSize.s14,
                      color: getDarkTextColor(controller.isDark.value,
                          controller.focusSharpness.value),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      controller.blurFocusLevels.length,
                          (index) => ElevatedButton(
                        onPressed: () async {
                          final blur =
                          controller.blurFocusLevels[index]['blur']!;
                          final focus =
                          controller.blurFocusLevels[index]['focus']!;

                          controller.blurAmount.value = blur;
                          controller.focusSharpness.value = focus;

                          controller.prefs
                              .setDouble(key: 'blurAmount', value: blur);
                          controller.prefs.setDouble(
                              key: 'focusSharpness', value: focus);

                          SharedPreferences.getInstance().then((sp) {
                            sp.setString(
                                "flutter.blurAmount", blur.toString());
                            sp.setString(
                                "flutter.focusSharpness", focus.toString());
                          });

                          await controller.updateOverlay();

                          Get.snackbar(
                            ManagerStrings.activated,
                            "${ManagerStrings.level} ${index + 1} ${ManagerStrings.success}",
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          backgroundColor: Colors.grey[300],
                          foregroundColor: getDarkTextColor(
                              controller.isDark.value,
                              controller.focusSharpness.value),
                        ),
                        child: Text("${ManagerStrings.level} ${index + 1}"),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                Text(
                  ManagerStrings.language,
                  style: getMediumTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: getDarkTextColor(
                      controller.isDark.value,
                      controller.focusSharpness.value,
                    ),
                  ),
                ),
                Obx(
                      () => DropdownButton<Locale>(
                    value: controller.currentLocale.value,
                    items: LocaleSettings.languages.entries.map((entry) {
                      return DropdownMenuItem(
                        value: Locale(entry.key),
                        child: Text(
                          entry.value.tr,
                          style: getRegularTextStyle(
                            fontSize: ManagerFontSize.s14,
                            color: getDarkTextColor(
                              controller.isDark.value,
                              controller.focusSharpness.value,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (locale) {
                      if (locale != null) {
                        controller.changeLanguage(locale, context);
                      }
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  ManagerStrings.addMode,
                  style: getMediumTextStyle(
                    fontSize: ManagerFontSize.s16,
                    color: getDarkTextColor(controller.isDark.value,
                        controller.focusSharpness.value),
                  ),
                ),
                const SizedBox(height: 8),
                textField(
                  controller: controller.filterNameController,
                  hintText: ManagerStrings.mode,
                  hintStyle: getRegularTextStyle(
                    fontSize: ManagerFontSize.s12,
                    color: getDarkTextColor(controller.isDark.value,
                        controller.focusSharpness.value)
                        .withOpacity(0.7),
                  ),
                  style: getRegularTextStyle(
                    fontSize: ManagerFontSize.s14,
                    color: getDarkTextColor(controller.isDark.value,
                        controller.focusSharpness.value),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    await controller.applyFilterAndRestartOverlay(
                      warmth: controller.colorWarmth.value,
                      blur: controller.blurAmount.value,
                      focus: controller.focusSharpness.value,
                    );
                    await controller.saveCustomFilter();
                    Get.snackbar(
                      ManagerStrings.filterActivated,
                      ManagerStrings.generalFilterSaved,
                    );
                  },
                  icon: Icon(
                    Icons.remove_red_eye_outlined,
                    color: getDarkTextColor(
                      controller.isDark.value,
                      controller.focusSharpness.value,
                    ),
                  ),
                  label: Text(
                    ManagerStrings.save,
                    style: getMediumTextStyle(
                      fontSize: ManagerFontSize.s12,
                      color: getDarkTextColor(
                        controller.isDark.value,
                        controller.focusSharpness.value,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 102),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final Uri url =
                          Uri.parse('https://emall.com.sa/support');
                          if (!await launchUrl(url,
                              mode: LaunchMode.externalApplication)) {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Text(
                          ManagerStrings.contactUs,
                          style: getMediumTextStyle(
                              fontSize: 16, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        '|',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                              const PrivacyPolicyView(),
                            ),
                          );
                        },
                        child: Text(
                          ManagerStrings.privacyPolicy,
                          style: getMediumTextStyle(
                              fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          if (controller.enableBlur.value &&
              controller.blurAmount.value > 0)
            Positioned.fill(
              child: IgnorePointer(
                ignoring: true,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: controller.blurAmount.value,
                    sigmaY: controller.blurAmount.value *
                        (1 - controller.focusSharpness.value),
                  ),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
        ],
      )),
    );
  }
}
