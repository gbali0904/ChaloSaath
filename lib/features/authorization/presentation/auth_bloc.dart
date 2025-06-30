import 'package:chalosaath/features/authorization/data/authEvent.dart';
import 'package:chalosaath/features/authorization/data/authState.dart';
import 'package:chalosaath/features/authorization/domain/get_userType_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthorizationBloc extends Bloc<AuthEvent, AuthState>
{
  final GetUsertypeData getUsertypeData;

  AuthorizationBloc(this.getUsertypeData) : super(AuthLoading()) {
    on<LoadUserTypeData>((event, emit) {
      emit(AuthLoading());
      final data = getUsertypeData();
      emit(UserTypeLoaded(data));
    });

    on<RoleChanged>((event, emit) {
      emit(RoleChangedData(event.role));
    });

  }

}
