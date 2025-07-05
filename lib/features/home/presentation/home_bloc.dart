import 'package:chalosaath/features/home/data/HomeEvent.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../authorization/data/user_model.dart';
import '../../data_providers/domain/base_firebase_service.dart';
import '../../home/data/HomeState.dart';
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  BaseFirebaseService firebase;
  HomeBloc(this.firebase) : super(HomeLoading()) {
    on<SaveUserAddress>((event, emit) async {
      emit(HomeLoading());
      try {
        final UserModel? userData = await firebase.updateUserAddresses(event.userModel);
        emit(HomeLoaded(userData!));
      } on FirebaseAuthException catch (e) {
        emit(HomeError("${e.message}"));
        throw Exception(e.message ?? 'Registration failed');
      }

    });
    on<GetUserList>((event, emit) async {
      emit(HomeLoading());
      try {
        final List<UserModel> userData = await firebase.getUserList(event.role);
        emit(UserDataSuccess(userData));
      } on FirebaseAuthException catch (e) {
        emit(HomeError("${e.message}"));
        throw Exception(e.message ?? 'Registration failed');
      }

    });
  }
}
