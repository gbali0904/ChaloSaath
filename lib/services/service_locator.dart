import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/storage/app_preferences.dart';
import '../features/address/domain/address_repo.dart';
import '../features/address/domain/address_repo_impl.dart';
import '../features/address/presentation/address_search_bloc.dart';
import '../features/authorization/domain/get_user_type_data.dart';
import '../features/authorization/domain/repositories/auth_repository.dart';
import '../features/authorization/domain/repositories/auth_repository_impl.dart';
import '../features/authorization/presentation/auth_bloc.dart';
import '../features/data_providers/data/firebase_service_impl.dart';
import '../features/data_providers/data/social_sign_in_service_impl.dart';
import '../features/data_providers/domain/base_firebase_service.dart';
import '../features/data_providers/domain/social_sign_in_service.dart';
import '../features/home/presentation/home_bloc.dart';
import '../features/onboarding/domain/get_onboarding_data.dart';
import '../features/onboarding/presentation/onboarding_bloc.dart';
import '../features/profile/presentation/profile_setup_bloc.dart';

final getX = GetIt.instance;

Future<void> setupLocator() async {
  getX.registerLazySingleton(() => GetOnboardingData());
  getX.registerLazySingleton(() => GetUsertypeData());
  getX.registerFactory(() => OnboardingBloc(getX()));
  getX.registerFactory<AddressRepo>(() => AddressRepoImpl(getX<BaseFirebaseService>()));
  getX.registerFactory(() => AddressSearchBloc(getX<AddressRepo>()));
  getX.registerFactory(() => HomeBloc(getX<BaseFirebaseService>()));
  getX.registerFactory(
    () => AuthorizationBloc(getX<GetUsertypeData>(), getX<AuthRepository>()),
  );
  getX.registerFactory(() => ProfileSetupBloc(getX<BaseFirebaseService>()));

  final sharedPrefs = await SharedPreferences.getInstance();
  getX.registerLazySingleton(() => AppPreference(sharedPrefs));

  getX.registerLazySingleton(() => FirebaseAuth.instance);
  getX.registerLazySingleton(() => FirebaseFirestore.instance);

  getX.registerFactory<SocialSignInService>(() => SocialSignInServiceImpl());
  getX.registerLazySingleton<BaseFirebaseService>(
    () => FirebaseServiceImpl(getX<SocialSignInService>()),
  );

  getX.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(getX<BaseFirebaseService>()),
  );
}
