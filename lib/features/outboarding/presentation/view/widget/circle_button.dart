import 'package:flutter/material.dart';
import '../../../../../core/resources/manager_colors.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_width.dart';
import '../../../../../core/widget/main_button.dart';

Widget circleButton({
  required void Function() onPressed,
  required IconData iconData,
}) {
  return mainButton(
    onPressed: onPressed,
    child: Icon(
      iconData,
      color: ManagerColors.blue,
    ),
    shapeBorder: const CircleBorder(),
    minWidth: ManagerWidth.w50,
    height: ManagerHeight.h50,
    color: ManagerColors.background,
  );
}