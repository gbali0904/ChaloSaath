import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'offer_ride_event.dart';
import 'offer_ride_state.dart';
import '../../data_providers/domain/base_firebase_service.dart';
import '../../../services/service_locator.dart';

class OfferRideBloc extends Bloc<OfferRideEvent, OfferRideState> {
  final BaseFirebaseService firebaseService;
  OfferRideBloc({BaseFirebaseService? firebase})
      : firebaseService = firebase ?? getX<BaseFirebaseService>(),
        super(OfferRideState()) {
    on<PickupChanged>((event, emit) => emit(state.copyWith(pickup: event.pickup)));
    on<DestinationChanged>((event, emit) => emit(state.copyWith(destination: event.destination)));
    on<DateChanged>((event, emit) => emit(state.copyWith(date: event.date)));
    on<TimeChanged>((event, emit) => emit(state.copyWith(time: event.time)));
    on<RecurringChanged>((event, emit) => emit(state.copyWith(recurring: event.recurring)));
    on<SeatsChanged>((event, emit) => emit(state.copyWith(seats: event.seats)));
    on<FareChanged>((event, emit) => emit(state.copyWith(fare: event.fare)));
    on<NotesChanged>((event, emit) => emit(state.copyWith(notes: event.notes)));
    on<SubmitOfferRide>(_onSubmit);
  }

  Future<void> _onSubmit(SubmitOfferRide event, Emitter<OfferRideState> emit) async {
    emit(state.copyWith(isLoading: true, error: null, isSuccess: false));
    try {
      final rideData = {
        'pickup': state.pickup,
        'destination': state.destination,
        'date': state.date?.toIso8601String(),
        'time': state.time != null ? '${state.time!.hour.toString().padLeft(2, '0')}:${state.time!.minute.toString().padLeft(2, '0')}' : null,
        'recurring': state.recurring,
        'seats': state.seats,
        'fare': state.fare,
        'notes': state.notes,
        'createdAt': DateTime.now().toIso8601String(),
      };
      await firebaseService.saveRide(rideData);
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
} 