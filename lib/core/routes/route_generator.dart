import 'package:flutter/material.dart';
import 'route_constants.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/onboarding/presentation/onboarding_bloc.dart';
import '../../features/authorization/presentation/login_screen.dart';
import '../../features/authorization/presentation/signup_screen.dart';
import '../../features/authorization/presentation/auth_screen.dart';
import '../../features/authorization/presentation/auth_bloc.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/home/presentation/home_bloc.dart';
import '../../features/main/main_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/address/presentation/address_form.dart';
import '../../features/address/presentation/address_search_bloc.dart';
import '../../services/service_locator.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Default to splash screen for any unknown routes
    if (settings.name == null) {
      return _buildSplashRoute(settings);
    }

    switch (settings.name) {
      case RouteConstants.splash:
        return _buildSplashRoute(settings);

      case RouteConstants.onboarding:
        return MaterialPageRoute(
          builder: (_) => OnboardingScreen(bloc: getX<OnboardingBloc>()),
          settings: settings,
        );

      case RouteConstants.login:
        return MaterialPageRoute(
          builder: (_) => LoginScreen(bloc: getX<AuthorizationBloc>()),
          settings: settings,
        );

      case RouteConstants.signup:
        final args = settings.arguments as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => SignUpScreen(
            bloc: getX<AuthorizationBloc>(),
            args: args,
          ),
          settings: settings,
        );

      case RouteConstants.auth:
        return MaterialPageRoute(
          builder: (_) => AuthScreen(bloc: getX<AuthorizationBloc>()),
          settings: settings,
        );

      case RouteConstants.home:
        return MaterialPageRoute(
          builder: (_) => HomeScreen(
            bloc: getX<AddressSearchBloc>(),
            home_bloc: getX<HomeBloc>(),
          ),
          settings: settings,
        );

      case RouteConstants.main:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
          settings: settings,
        );

      case RouteConstants.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
          settings: settings,
        );

      case RouteConstants.addressForm:
        final args = settings.arguments as bool? ?? false;
        return MaterialPageRoute(
          builder: (_) => AddressScreen(
            bloc: getX<AddressSearchBloc>(),
            home_bloc: getX<HomeBloc>(),
            arg: args,
          ),
          settings: settings,
        );

      case RouteConstants.addressSearch:
        return MaterialPageRoute(
          builder: (_) => AddressScreen(
            bloc: getX<AddressSearchBloc>(),
            home_bloc: getX<HomeBloc>(),
            arg: false,
          ),
          settings: settings,
        );

      // Default case - redirect to splash screen
      default:
        return _buildSplashRoute(settings);
    }
  }

  // Helper method to build splash route
  static MaterialPageRoute _buildSplashRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => const SplashScreen(),
      settings: settings,
    );
  }

  // Navigation helper methods
  static void navigateToSplash(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteConstants.splash,
      (route) => false,
    );
  }

  static void navigateToOnboarding(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteConstants.onboarding,
      (route) => false,
    );
  }

  static void navigateToAuth(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteConstants.auth,
      (route) => false,
    );
  }

  static void navigateToMain(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteConstants.main,
      (route) => false,
    );
  }

  static void navigateToHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteConstants.home,
      (route) => false,
    );
  }

  static void navigateToLogin(BuildContext context) {
    Navigator.of(context).pushNamed(RouteConstants.login);
  }

  static void navigateToSignup(BuildContext context) {
    Navigator.of(context).pushNamed(RouteConstants.signup);
  }

  static void navigateToProfile(BuildContext context) {
    Navigator.of(context).pushNamed(RouteConstants.profile);
  }

  static void navigateToAddressForm(BuildContext context) {
    Navigator.of(context).pushNamed(RouteConstants.addressForm);
  }

  static void navigateToAddressSearch(BuildContext context) {
    Navigator.of(context).pushNamed(RouteConstants.addressSearch);
  }

  // Navigation with arguments
  static void navigateToWithArguments(
    BuildContext context,
    String routeName,
    Object arguments,
  ) {
    Navigator.of(context).pushNamed(routeName, arguments: arguments);
  }

  // Navigation with result
  static Future<T?> navigateToWithResult<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(context).pushNamed<T>(routeName, arguments: arguments);
  }

  // Replace current route
  static void replaceRoute(BuildContext context, String routeName) {
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  // Pop and navigate
  static void popAndNavigate(BuildContext context, String routeName) {
    Navigator.of(context).pop();
    Navigator.of(context).pushNamed(routeName);
  }

  // Pop until specific route
  static void popUntilRoute(BuildContext context, String routeName) {
    Navigator.of(context).popUntil(ModalRoute.withName(routeName));
  }

  // Can pop check
  static bool canPop(BuildContext context) {
    return Navigator.of(context).canPop();
  }

  // Pop with result
  static void popWithResult<T>(BuildContext context, T result) {
    Navigator.of(context).pop(result);
  }
}
