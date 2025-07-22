import 'package:chalosaath/features/authorization/data/user_model.dart';
import 'package:chalosaath/features/home/data/Ride.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final UserModel userData;

  HomeLoaded(this.userData);
}
class UserDataSuccess extends HomeState {
  final List<UserModel> userData;
  UserDataSuccess(this.userData);
}
class RideDataSuccess extends HomeState {
  final List<Ride> rideData;
  RideDataSuccess(this.rideData);
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
