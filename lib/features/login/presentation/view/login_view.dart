import 'package:app_mobile/core/resources/manager_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) {
        return Scaffold(
          body: Center(
            child: MaterialButton(
              onPressed: () {
              },
              child: Text(
                ManagerStrings.success,
              ),
            ),
          ),
        );
      },
    );
  }
}
