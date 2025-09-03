import 'package:app_mobile/features/home/presentation/view/home_view.dart';
import 'package:app_mobile/features/login/domain/di/di.dart';
import 'package:app_mobile/features/login/presentation/view/login_view.dart';
import 'package:app_mobile/features/outboarding/presentation/view/screen/out_boarding_view.dart';
import 'package:app_mobile/features/settings/presentation/view/settings_view.dart';
import 'package:app_mobile/features/splash/presentation/view/splash_view.dart';
import 'package:flutter/material.dart';
import '../resources/manager_strings.dart';

/// A class defined for all routes constants
class Routes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String outboarding = '/outboarding';
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        initSplash();
        return MaterialPageRoute(builder: (_) => const LoginView());
      case Routes.splash:
        // initLogin();
        return MaterialPageRoute(builder: (_) => const SplashView());
      case Routes.home:
        initHome();
        return MaterialPageRoute(builder: (_) => const HomeView());
      case Routes.settings:
        initSettings();
        return MaterialPageRoute(builder: (_) => const SettingsView());
      case Routes.outboarding:
        initOutBoarding();
        return MaterialPageRoute(builder: (_) => const OutBoardingView());
      default:
        return unDefinedRoute();
    }
  }

  /// If PushNamed Failed Return This Page With No Actions
  /// This Screen Will Tell The User This Page Is Not Exist
  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(
            ManagerStrings.noRouteFound,
          ),
        ),
        body: Center(
          child: Text(
            ManagerStrings.noRouteFound,
          ),
        ),
      ),
    );
  }
}
