import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import '../../../../constants/di/dependency_injection.dart';
import '../../../../core/network/app_api.dart';
import '../../../home/presentation/controller/home_controller.dart';
import '../../../outboarding/presentation/controller/out_boarding_controller.dart';
import '../../../settings/presentation/controller/settings_controller.dart';
import '../../../splash/presentation/controller/splash_controller.dart';
import '../../presentation/controller/login_controller.dart';



initSplash() {
  Get.put<SplashController>(SplashController());
}


initHome() {
  Get.put<HomeController>(HomeController());
}
initSettings() {
  Get.put<SettingsController>(SettingsController());
}
finishSplash() {
  Get.delete<SplashController>();
}
initOutBoarding() {
  finishSplash();
  Get.put<OutBoardingController>(OutBoardingController());
}

finishOutBoarding() {
  Get.delete<OutBoardingController>();
}


