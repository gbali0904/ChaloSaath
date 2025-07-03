import 'package:chalosaath/features/authorization/data/user_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final UserModel userData;

  HomeLoaded(this.userData);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
