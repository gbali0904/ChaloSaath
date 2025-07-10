import 'package:flutter_bloc/flutter_bloc.dart';
import '../../authorization/data/user_model.dart';
import '../../data_providers/domain/base_firebase_service.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class ProfileSetupEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileSetupSubmitted extends ProfileSetupEvent {
  final UserModel user;
  ProfileSetupSubmitted(this.user);
  @override
  List<Object?> get props => [user];
}

// States
abstract class ProfileSetupState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileSetupInitial extends ProfileSetupState {}
class ProfileSetupLoading extends ProfileSetupState {}
class ProfileSetupSuccess extends ProfileSetupState {}
class ProfileSetupFailure extends ProfileSetupState {
  final String message;
  ProfileSetupFailure(this.message);
  @override
  List<Object?> get props => [message];
}

class ProfileSetupBloc extends Bloc<ProfileSetupEvent, ProfileSetupState> {
  final BaseFirebaseService firebaseService;
  ProfileSetupBloc(this.firebaseService) : super(ProfileSetupInitial()) {
    on<ProfileSetupSubmitted>((event, emit) async {
      emit(ProfileSetupLoading());
      try {
        await firebaseService.saveUserData(event.user.phone, event.user);
        emit(ProfileSetupSuccess());
      } catch (e) {
        emit(ProfileSetupFailure(e.toString()));
      }
    });
  }
} 