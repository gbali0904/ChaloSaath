abstract class AddressSearchState {}

class AddressInitial extends AddressSearchState {}

class AddressLoading extends AddressSearchState {}

class AddressLoaded extends AddressSearchState {
  final List<String> suggestions;

  AddressLoaded(this.suggestions);
}

class AddressError extends AddressSearchState {
  final String message;

  AddressError(this.message);
}
