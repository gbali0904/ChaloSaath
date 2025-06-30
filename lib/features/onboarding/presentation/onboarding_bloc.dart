import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/OnboardingEvent.dart';
import '../data/OnboardingState.dart';
import '../domain/get_onboarding_data.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  final GetOnboardingData getOnboardingData;

  OnboardingBloc(this.getOnboardingData) : super(OnboardingInitial()) {
    on<LoadOnboardingData>((event, emit) {
      emit(OnboardingLoading());
      final data = getOnboardingData();
      emit(OnboardingLoaded(data));
    });
  }
}