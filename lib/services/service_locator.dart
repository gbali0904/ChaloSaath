import 'package:chalosaath/features/data_providers/data/SocialSignInServiceImpl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/storage/app_preferences.dart';
import '../features/authorization/domain/get_userType_data.dart';
import '../features/authorization/domain/repositories/auth_repository.dart';
import '../features/authorization/domain/repositories/auth_repository_impl.dart';
import '../features/authorization/presentation/auth_bloc.dart';
import '../features/data_providers/data/FirebaseServiceImpl.dart';
import '../features/data_providers/domain/BaseFirebaseService.dart';
import '../features/data_providers/domain/SocialSignInService.dart';
import '../features/onboarding/domain/get_onboarding_data.dart';
import '../features/onboarding/presentation/onboarding_bloc.dart';

final getX = GetIt.instance;

Future<void> setupLocator() async {
  getX.registerLazySingleton(() => GetOnboardingData());
  getX.registerLazySingleton(() => GetUsertypeData());
  getX.registerFactory(() => OnboardingBloc(getX()));
  getX.registerFactory(
    () => AuthorizationBloc(getX<GetUsertypeData>(), getX<AuthRepository>()),
  );

  final sharedPrefs = await SharedPreferences.getInstance();
  getX.registerLazySingleton(() => AppPreference(sharedPrefs));

  getX.registerLazySingleton(() => FirebaseAuth.instance);
  getX.registerLazySingleton(() => FirebaseFirestore.instance);
  getX.registerLazySingleton<BaseFirebaseService>(
    () => FirebaseServiceImpl(getX<SocialSignInService>()),
  );

  getX.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getX<BaseFirebaseService>()),
  );
}
