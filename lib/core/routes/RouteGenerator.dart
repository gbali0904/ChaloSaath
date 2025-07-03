import 'package:chalosaath/features/authorization/presentation/auth_bloc.dart';
import 'package:chalosaath/features/address/presentation/AddressSearchBloc.dart';
import 'package:chalosaath/features/home/presentation/HomeBloc.dart';
import 'package:chalosaath/features/onboarding/presentation/onboarding_bloc.dart';
import 'package:flutter/material.dart';
import '../../features/address/presentation/AddressForm.dart';
import '../../features/authorization/presentation/AuthScreen.dart';
import '../../features/authorization/presentation/LoginScreen.dart';
import '../../features/authorization/presentation/SignUpScreen.dart';
import '../../features/home/presentation/HomeScreen.dart';
import '../../features/main/MainScreen.dart';
import '../../features/onboarding/presentation/OnboardingScreen.dart';
import '../../features/profile/presentation/ProfileScreen.dart';
import '../../features/splash/SplashScren.dart';
import '../../services/service_locator.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case '/onboarding':
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen(bloc: getX<OnboardingBloc>()),
        );
      case '/auth':
        return MaterialPageRoute(
          builder: (_) => AuthScreen(bloc: getX<AuthorizationBloc>()),
        );
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginScreen(bloc: getX<AuthorizationBloc>()),
        );
      case '/signup':
        final args = settings.arguments as bool;
        return MaterialPageRoute(
          builder: (_) =>
              SignUpScreen(bloc: getX<AuthorizationBloc>(), args: args),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => HomeScreen(
            bloc: getX<AddressSearchBloc>(),
            home_bloc: getX<HomeBloc>(),
          ),
        );
      case '/address':
        final args = settings.arguments as bool;
        return MaterialPageRoute(
          builder: (_) => AddressScreen(
            bloc: getX<AddressSearchBloc>(),
            home_bloc: getX<HomeBloc>(),
            arg: args,
          ),
        );
      case '/main':
        return MaterialPageRoute(builder: (_) => MainScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
