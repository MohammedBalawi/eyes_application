import 'package:app_mobile/core/resources/manager_font_size.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/privacy_policy_controller.dart';
import '../../../../core/resources/manager_styles.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});

  @override
  Widget build(BuildContext context) {
    final PrivacyPolicyController controller = Get.put(PrivacyPolicyController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.title.value)),
        backgroundColor: Colors.blueGrey,
        centerTitle: true,
      ),
      body: Obx(() => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          controller.content.value,
          style: getRegularTextStyle(fontSize: ManagerFontSize.s16, color: Colors.black87),
        ),
      )),
    );
  }
}
