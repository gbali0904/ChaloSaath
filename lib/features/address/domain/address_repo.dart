abstract class AddressRepo {
  Future<List<String>> fetchAddressSuggestions(String query);
}
