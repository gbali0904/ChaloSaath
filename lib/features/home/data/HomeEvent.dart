import 'package:chalosaath/features/authorization/data/user_model.dart';

abstract class HomeEvent {}

class SaveUserAddress extends HomeEvent {
  final UserModel userModel;
  SaveUserAddress(this.userModel);
}
