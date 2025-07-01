import 'package:chalosaath/features/authorization/data/authEvent.dart';
import 'package:chalosaath/features/authorization/data/authState.dart';
import 'package:chalosaath/features/authorization/domain/get_userType_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/user_model.dart';
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


    on<SignInWithGoogle>((event, emit) async {
      emit(AuthLoading());
      try {
        final UserCredential? userCredential =  await repository.googleLogin();
        emit(LoginSuccess(userCredential!));
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

/*
    on<SignInWithWhatsApp>((event, emit) async {
      emit(AuthLoading());
      try {
        // WhatsApp Deep Link
        final uri = Uri.parse("https://wa.me/${event.phoneNumber}");
        await launchUrl(uri, mode: LaunchMode.externalApplication);

        // Simulate verification via Firebase Phone Auth (actual implementation required)
        await _auth.verifyPhoneNumber(
          phoneNumber: "+91${event.phoneNumber}",
          verificationCompleted: (cred) async {
            final userCred = await _auth.signInWithCredential(cred);
            emit(AuthSuccess(userCred.user!));
          },
          verificationFailed: (e) {
            emit(AuthFailure("Verification failed: ${e.message}"));
          },
          codeSent: (id, _) {
            emit(AuthFailure("OTP sent. Handle next step manually."));
          },
          codeAutoRetrievalTimeout: (_) {},
        );
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });*/

  }

}
