import 'package:app_mobile/core/extensions/extensions.dart';
import 'package:app_mobile/core/resources/manager_styles.dart';
import 'package:flutter/material.dart';
import '../resources/manager_colors.dart';
import '../resources/manager_font_size.dart';
import '../resources/manager_height.dart';
import '../resources/manager_radius.dart';
import '../resources/manager_width.dart';

Widget textField(
    {required String hintText,
      bool? obSecure,
      bool? isInt,
      required TextEditingController controller,
      validator,
      Widget? suffixIcon,
      Widget? prefixIcon,
      void Function()? onTap,
      onChange,
      TextInputType? textInputType,
      FocusNode? focusNode,
      double? radius,
      Color? fillColor,
      int? maxLines, required TextStyle hintStyle, required TextStyle style}) {
  return TextFormField(
    controller: controller,
    validator: validator,
    style: getRegularTextStyle(
        fontSize: ManagerFontSize.s16,
        color: ManagerColors.black),
    obscureText: obSecure.onNull(),
    keyboardType: textInputType,
    onTap: onTap,
    maxLines: obSecure == true ? 1 : maxLines, // Ensure maxLines is 1 if obSecure is true
    focusNode: focusNode,
    onChanged: onChange ?? (val) {},
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      contentPadding: EdgeInsets.symmetric(
        vertical: ManagerHeight.h10,
        horizontal: ManagerWidth.w10,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          radius ?? ManagerRadius.r6,
        ),
        borderSide: const BorderSide(
          color: ManagerColors.grey,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          radius ?? ManagerRadius.r10,
        ),
        borderSide: const BorderSide(
          color: ManagerColors.grey,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          radius ?? ManagerRadius.r6,
        ),
        borderSide: const BorderSide(
          color: ManagerColors.grey,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          radius ?? ManagerRadius.r6,
        ),
        borderSide: const BorderSide(
          color: ManagerColors.grey,
        ),
      ),
      filled: true,
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      fillColor: fillColor ?? ManagerColors.white,
      hintText: hintText,
      hintStyle: getRegularTextStyle(
        fontSize: ManagerFontSize.s16,
        color: ManagerColors.grey,
      ),
    ),
  );
}
