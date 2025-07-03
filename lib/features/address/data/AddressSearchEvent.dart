abstract class AddressSearchEvent {}

class FetchAddressSuggestions extends AddressSearchEvent {
  final String query;

  FetchAddressSuggestions(this.query);
}
