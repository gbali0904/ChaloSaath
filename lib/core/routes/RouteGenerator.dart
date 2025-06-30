import 'package:chalosaath/features/onboarding/presentation/onboarding_bloc.dart';
import 'package:flutter/material.dart';

import '../../features/main/MainScreen.dart';
import '../../features/onboarding/presentation/OnboardingScreen.dart';
import '../../features/splash/SplashScren.dart';
import '../../services/service_locator.dart';
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => OnboardingScreen(bloc: getX<OnboardingBloc>(),));
      case '/main':
        return MaterialPageRoute(builder: (_) => MainScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
