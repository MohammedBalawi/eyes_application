import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import '../resources/manager_font_size.dart';
import '../resources/manager_height.dart';
import '../resources/manager_radius.dart';

Widget mainButton({
  required void Function() onPressed,
  String? buttonName,
  double? minWidth,
  Widget? child,
  Color? color,
  double? radius,
  double? height,
  ShapeBorder? shapeBorder,
  double? elevation,
  EdgeInsetsGeometry? padding,
  ShapeDecoration? shapeDecoration,
  bool isLoading = false,
  bool isBold = false,
  bool enabled = true,
}) {
  return Container(
    decoration: shapeDecoration ?? null,
    child: MaterialButton(
      padding: padding,
      onPressed: (isLoading || !enabled) ? () {} : onPressed,
      minWidth: minWidth.onNull(),
      height: height ?? ManagerHeight.h48,
      color: shapeDecoration != null
          ? null
          : color ??
          (enabled ? ManagerColors.textColor : ManagerColors.grey30),
      elevation: elevation ?? 2,
      shape: shapeBorder ??
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              radius ?? ManagerRadius.r10,
            ),
          ),
      child: isLoading
          ? const CircularProgressIndicator(
        color: ManagerColors.textColor,
      )
          : child ??
          Text(
            buttonName.onNull(),
            style: isBold
                ? getBoldTextStyle(
              fontSize: ManagerFontSize.s16,
              color:
              enabled ? ManagerColors.white : ManagerColors.grey,
            )
                : getRegularTextStyle(
              fontSize: ManagerFontSize.s16,
              color:
              enabled ? ManagerColors.white : ManagerColors.grey,
            ),
          ),
    ),
  );
}
