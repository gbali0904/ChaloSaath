import 'package:chalosaath/features/authorization/data/authEvent.dart';
import 'package:chalosaath/features/authorization/data/authState.dart';
import 'package:chalosaath/features/authorization/domain/get_userType_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/repositories/auth_repository.dart';

class AuthorizationBloc extends Bloc<AuthEvent, AuthState>
{
  final GetUsertypeData getUsertypeData;
  final AuthRepository repository;

  AuthorizationBloc(this.getUsertypeData, this.repository) : super(AuthLoading()) {
    on<LoadUserTypeData>((event, emit) {
      emit(AuthLoading());
      final data = getUsertypeData();
      emit(UserTypeLoaded(data));
    });

    on<RoleChanged>((event, emit) {
      emit(RoleChangedData(event.role));
    });

    on<RegisterUser>((event, emit) async {
      emit(AuthLoading());

      try {
        await repository.registerUser(
          userData: event.userData,
        );
        emit(AuthSuccess());
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }

    });

    on<LoginIN>((event, emit) async {
      emit(AuthLoading());

      try {
        var userCredential = await repository.loginUser(
          email: event.email,
          password: event.password,
        );
        emit(LoginSuccess(userCredential!));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }

    });

  }

}
