import 'package:chalosaath/features/onboarding/data/onboarding_model.dart';

abstract class OnboardingState {}

class OnboardingInitial extends OnboardingState {}

class OnboardingLoading extends OnboardingState {}

class OnboardingLoaded extends OnboardingState {
  final List<OnboardingModel> data;

  OnboardingLoaded(this.data);
}
