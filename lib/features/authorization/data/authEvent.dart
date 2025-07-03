import 'package:chalosaath/features/authorization/data/user_model.dart';

abstract class AuthEvent {}

class LoadUserTypeData extends AuthEvent {}
class RoleChanged extends AuthEvent {
  final String role;
  RoleChanged(this.role);
}
class RegisterUser extends AuthEvent{
  final UserModel userData;
  RegisterUser(this.userData);
}

class SignInWithGoogle extends AuthEvent {}

class SignInWithWhatsApp extends AuthEvent {
  final String phoneNumber;
  SignInWithWhatsApp(this.phoneNumber);
}
class LoginIN extends AuthEvent{
  String email;
  String password;
  LoginIN( this.email,  this.password) ;
}

class CheckUser extends AuthEvent{
  String email;
  CheckUser( this.email) ;
}
