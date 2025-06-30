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