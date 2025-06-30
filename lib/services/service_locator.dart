import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/storage/app_preferences.dart';
import '../features/onboarding/domain/get_onboarding_data.dart';
import '../features/onboarding/presentation/onboarding_bloc.dart';
final getX = GetIt.instance;

Future<void> setupLocator() async {
  getX.registerLazySingleton(() => GetOnboardingData());
  getX.registerFactory(() => OnboardingBloc(getX()));

  final sharedPrefs = await SharedPreferences.getInstance();
  getX.registerLazySingleton(() => AppPreference(sharedPrefs));
}
