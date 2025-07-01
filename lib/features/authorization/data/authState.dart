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

class AuthSuccess extends AuthState {}
class LoginSuccess extends AuthState {
  final UserCredential userCredential;
  LoginSuccess(this.userCredential);
}
class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}