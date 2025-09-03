import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants/constants/constants.dart';
import '../../../../core/locale/locale_controller.dart';
import '../../../../core/resources/manager_images.dart';
import '../../../../core/resources/manager_strings.dart';
import '../../../../core/routes/routes.dart';
import '../view/widget/out_boarding_item.dart';

class OutBoardingController extends GetxController {
  List<OutBoardingItem> outBoardingItems = [
    OutBoardingItem(
      title: ManagerStrings.onboardingTitle1,
      subTitle: ManagerStrings.onboardingSubtitle1,
      image: ManagerImages.image_out_1,
    ),
    OutBoardingItem(
      title: ManagerStrings.onboardingTitle2,
      subTitle: ManagerStrings.onboardingSubtitle2,
      image: ManagerImages.image_out_2,
    ),
    OutBoardingItem(
      title: ManagerStrings.onboardingTitle3,
      subTitle: ManagerStrings.onboardingSubtitle3,
      image: ManagerImages.image_out_3,
    ),
  ];

  String buttonNextText = 'Continue';
  static const firstPage = 0;
  static const lastPage = 2;
  static int currentPage = 0;
  late PageController pageController;

  @override
  void onInit() {
    super.onInit();
    _initLocale();
    pageController = PageController();
  }

  Future<void> _initLocale() async {
    final prefs = await SharedPreferences.getInstance();
    String locale = prefs.getString('locale') ?? 'ar';
    LocaleController localeController = LocaleController();
    localeController.changeLanguage(locale);
  }

  int getCurrentPage() => currentPage;

  void setCurrentIndex(int index) {
    currentPage = index;
    setButtonText();
    update();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void skipPage() {
    animateToPage(index: lastPage);
    currentPage = lastPage;
    update();
  }

  void nextPage() {
    if (isNotLastedPage()) {
      animateToPage(index: ++currentPage);
      update();
    }
  }

  Future<void> getStart() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('outBoardingViewed', true);

    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      Get.offAllNamed(Routes.home);
    } else {
      Get.offAllNamed(Routes.home);
    }
  }

  void previousPage() {
    if (isNotFirstPage()) {
      animateToPage(index: --currentPage);
      update();
    }
  }

  void setButtonText() {
    buttonNextText = currentPage == lastPage ? 'Start' : 'Continue';
  }

  Future<void> animateToPage({required int index}) {
    return pageController.animateToPage(
      index,
      duration: const Duration(seconds: Constants.outBoardingDurationTime),
      curve: Curves.fastLinearToSlowEaseIn,
    );
  }

  bool isNotLastedPage() => currentPage < lastPage;

  bool isNotFirstPage() => currentPage > firstPage;

  bool showBackButton() => currentPage > firstPage && currentPage < lastPage;
}
