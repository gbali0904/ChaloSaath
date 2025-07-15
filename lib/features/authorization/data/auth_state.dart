import 'package:chalosaath/features/authorization/data/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class UserTypeLoaded extends AuthState {
  final List<String> data;
  UserTypeLoaded(this.data);
}

class RoleChangedData extends AuthState {
  final String data;
  RoleChangedData(this.data);
}

class AuthSuccess extends AuthState {
  UserModel? userCredential;
  AuthSuccess( this.userCredential);
}
class LoginSuccess extends AuthState {
  final UserModel userCredential;
  LoginSuccess(this.userCredential);
}
class UserSuccess extends AuthState {
  final UserModel? userCredential;
  UserSuccess(this.userCredential);
}
class UserFail extends AuthState{}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}