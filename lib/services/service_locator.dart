import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/storage/app_preferences.dart';
import '../features/authorization/domain/get_userType_data.dart';
import '../features/authorization/presentation/auth_bloc.dart';
import '../features/onboarding/domain/get_onboarding_data.dart';
import '../features/onboarding/presentation/onboarding_bloc.dart';
final getX = GetIt.instance;

Future<void> setupLocator() async {
  getX.registerLazySingleton(() => GetOnboardingData());
  getX.registerLazySingleton(() => GetUsertypeData());
  getX.registerFactory(() => OnboardingBloc(getX()));
  getX.registerFactory(() => AuthorizationBloc(getX()));

  final sharedPrefs = await SharedPreferences.getInstance();
  getX.registerLazySingleton(() => AppPreference(sharedPrefs));
}
