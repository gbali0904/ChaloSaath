abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<String> suggestions;

  HomeLoaded(this.suggestions);
}

class HomeError extends HomeState {
  final String message;

  HomeError(this.message);
}
