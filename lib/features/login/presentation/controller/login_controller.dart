import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/storage/local/app_settings_prefs.dart';

class LoginController extends GetxController {
  TextEditingController email =
      TextEditingController(text: "mayesh@flashflare.com");
  TextEditingController password =
      TextEditingController(text: 'mayesh@flashflare.com');
  var formKey = GlobalKey<FormState>();
  bool check = true;
  bool isObscurePassword = true;
  bool isLoading = false;

  onChangeObscurePassword() {
    isObscurePassword = !isObscurePassword;
    update();
  }

  onChange(bool status) {
    check = status;
    update();
  }

  void changeIsLoading({
    required bool value,
  }) {
    isLoading = value;
    update();
  }

  void performLogin() {
    if (formKey.currentState!.validate()) {
    }
  }


  @override
  void dispose() {
    email.dispose();
    password.dispose();
    formKey.currentState!.dispose();
    super.dispose();
  }
}
