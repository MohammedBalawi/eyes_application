import 'package:app_mobile/core/resources/manager_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../constants/constants/constants.dart';
import '../../../../../core/resources/manager_height.dart';
import '../../../../../core/resources/manager_radius.dart';
import '../../../../../core/resources/manager_width.dart';
import '../../controller/out_boarding_controller.dart';

class SliderIndicator extends StatelessWidget {
  const SliderIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return GetBuilder<OutBoardingController>(

      builder: (controller) {
        return Container(
          decoration: BoxDecoration(
            color: ManagerColors.grey30,
            borderRadius: BorderRadius.circular(
              ManagerRadius.r8,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(
                controller.outBoardingItems.length,
                (index) => AnimatedContainer(
                  duration:  const Duration(
                    milliseconds: Constants.sliderTimeMillSecond,
                  ),
                  width:  ManagerWidth.w68,
                  height: ManagerHeight.h4,
                  decoration: BoxDecoration(
                    color: controller.getCurrentPage() == index ? ManagerColors.textColor
                        : ManagerColors.grey30,
                    borderRadius: BorderRadius.circular(
                      ManagerRadius.r10,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
