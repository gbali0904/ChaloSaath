import 'dart:convert';
import 'package:http/http.dart' as http;

import 'AddressRepo.dart';

class AddressRepoImpl extends AddressRepo{
  AddressRepoImpl();

  @override
  Future<List<String>> fetchAddressSuggestions(String query) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=${Uri.encodeComponent(query)}'
          '&key=AIzaSyDYB7bOdYzLWFuDMjGcH7naEGQxeVK_YVc'
          '&components=country:in',
    );

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final predictions = jsonData['predictions'] as List;

      return predictions.map((e) => e['description'] as String).toList();
    } else {
      throw Exception("Failed to load suggestions: ${response.body}");
    }
  }
}
