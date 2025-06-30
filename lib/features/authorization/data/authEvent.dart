abstract class AuthEvent {}

class LoadUserTypeData extends AuthEvent {}
class RoleChanged extends AuthEvent {
  final String role;
  RoleChanged(this.role);
}
