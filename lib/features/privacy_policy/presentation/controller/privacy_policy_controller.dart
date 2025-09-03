import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:get/get.dart';
import '../modle/privacy_policy_model.dart';

class PrivacyPolicyController extends GetxController {
  final title = ''.obs;
  final content = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadPolicy();
  }

  void loadPolicy() {
    final policy = PrivacyPolicyModel(
      title: ManagerStrings.privacyPolicy ,
      content: ManagerStrings.privacyPolicySubTitel ,
    );

    title.value = policy.title;
    content.value = policy.content;
  }
}
