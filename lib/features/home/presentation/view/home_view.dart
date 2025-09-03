import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:app_mobile/core/resources/manager_height.dart';
import 'package:app_mobile/core/resources/manager_images.dart';
import 'package:app_mobile/core/resources/manager_radius.dart';
import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:app_mobile/core/routes/routes.dart';
import 'package:app_mobile/core/widget/in_app_webview.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../settings/presentation/controller/settings_controller.dart';
import '../controller/home_controller.dart';
import '../model/filter_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ManagerColors.white,
        title: Text(
          ManagerStrings.eyeFilter,
          style: getMediumTextStyle(
            fontSize: ManagerFontSize.s16,
            color: ManagerColors.textColor,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              final settingsController = Get.find<SettingsController>();
              settingsController.filterNameController.clear();
              settingsController.colorWarmth.value = 0.5;
              settingsController.blurAmount.value = 0.1;
              settingsController.enableBlur.value = false;
              settingsController.focusSharpness.value = 0.5;
              settingsController.contrastMode.value = 'light';
              Get.toNamed(Routes.settings);
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(ManagerRadius.r16),
        child: Stack(
          children: [
            Obx(
              () => ListView(
                children: [
                  _QuickShortcutsBar(),
                  SizedBox(height: ManagerHeight.h20),

                  Text(
                    ManagerStrings.readyFilters,
                    style: getBoldTextStyle(
                      fontSize: ManagerFontSize.s20,
                      color: ManagerColors.textColor,
                    ),
                  ),
                  SizedBox(height: ManagerHeight.h12),
                  ...controller.predefinedFilters
                      .map((filter) => _buildFilterBox(filter, controller)),
                  SizedBox(height: ManagerHeight.h30),
                  Text(
                    ManagerStrings.customFilters,
                    style: getMediumTextStyle(
                      fontSize: ManagerFontSize.s20,
                      color: ManagerColors.textColor,
                    ),
                  ),
                  SizedBox(height: ManagerHeight.h12),
                  ...controller.customFilters
                      .map((filter) => _buildFilterBox(filter, controller)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBox(FilterModel filter, HomeController controller) {
    return Obx(() {
      final isActive = controller.activeFilterName.value == filter.name;

      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: EdgeInsets.all(ManagerRadius.r16),
        decoration: BoxDecoration(
          color: isActive ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(ManagerRadius.r16),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
          border: Border.all(
            color: filter.isCustom ? Colors.deepPurple : Colors.blueAccent,
            width: 1.2,
          ),
        ),
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                isActive ? Icons.check_circle : Icons.remove_red_eye,
                size: 28,
                color: isActive ? Colors.green : Colors.blueAccent,
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => controller.activateFilter(filter),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      filter.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: ManagerHeight.h4),
                    Text(
                      "${ManagerStrings.temperature}: ${filter.temperature}K  |  ${ManagerStrings.opacity}: ${(filter.opacity * 100).round()}%",
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () => controller.activateFilter(filter),
              child: const Icon(Icons.tune, color: ManagerColors.grey),
            ),
            if (filter.isCustom)
              IconButton(
                icon: const Icon(Icons.dangerous, color: ManagerColors.red),
                onPressed: () {
                  Get.defaultDialog(
                    title: ManagerStrings.confirmDelete,
                    middleText:
                        '${ManagerStrings.confirmDelete} "${filter.name}"؟',
                    textConfirm: ManagerStrings.yesDelete,
                    textCancel: ManagerStrings.cancel,
                    confirmTextColor: ManagerColors.white,
                    onConfirm: () {
                      controller.deleteCustomFilter(filter.name);
                      Get.back();
                    },
                  );
                },
              ),
          ],
        ),
      );
    });
  }
}

class _QuickShortcutsBar extends StatelessWidget {
  _QuickShortcutsBar({super.key});

  final List<_QuickApp> _apps = [
    _QuickApp(
      name: 'WhatsApp',
      imagePath: ManagerImages.whatsApp,
      webUrl: 'https://web.whatsapp.com',
    ),
     _QuickApp(
      name: 'Instagram',
      imagePath: ManagerImages.instagram,
      webUrl: 'https://instagram.com',
    ),
     _QuickApp(
      name: 'Facebook',
      imagePath: ManagerImages.facebook,
      webUrl: 'https://facebook.com',
    ),
    _QuickApp(
      name: 'Snapchat',
      imagePath: ManagerImages.snap,
      webUrl: 'https://www.snapchat.com',
    ),

    _QuickApp(
      name: 'X (Twitter)',
      imagePath:ManagerImages.Twitter,
      webUrl: 'https://x.com',
    ),
     _QuickApp(
      name: 'YouTube',
      imagePath: ManagerImages.youtube,
      webUrl: 'https://m.youtube.com',
    ),
     _QuickApp(
      name: 'Chrome',
      imagePath: ManagerImages.chrome,
      webUrl: 'https://www.google.com',
    ),
    const _QuickApp(
      name: 'Google',
      imagePath: ManagerImages.google,
      webUrl: 'https://www.google.com',
    ),
     _QuickApp(
      name: 'PDF Reader',
      imagePath: ManagerImages.pdf,
      webUrl: 'https://www.africau.edu/images/default/sample.pdf',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _apps
              .map(
                (app) => Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _ShortcutChip(app: app),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _ShortcutChip extends StatelessWidget {
  const _ShortcutChip({required this.app});

  final _QuickApp app;

  void _openInWebView() {
    Get.to(() => InAppWebViewPage(
          url: app.webUrl,
          title: app.name,
          heroTag: 'hero-${app.name}',
        ));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _openInWebView,
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'hero-${app.name}',
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.grey.shade100,
                child:Image.asset(app.imagePath),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              app.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickApp {
  final String name;
  final String imagePath; // مسار الصورة بدل الأيقونة
  final String webUrl;

  const _QuickApp({
    required this.name,
    required this.imagePath,
    required this.webUrl,
  });
}
