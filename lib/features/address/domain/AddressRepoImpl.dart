import 'dart:convert';
import 'package:env_config/config/app_secrets.dart';
import 'package:http/http.dart' as http;

import '../../data_providers/domain/BaseFirebaseService.dart';
import 'AddressRepo.dart';

class AddressRepoImpl extends AddressRepo{
  final BaseFirebaseService _firebaseService;
  AddressRepoImpl(this._firebaseService);

  @override
  Future<List<String>> fetchAddressSuggestions(String query) async {
    List<String> existingLocations = await _firebaseService.searchLocationsFromFirebase(query);
    if (existingLocations.isNotEmpty) {
      print("here is coming");
      return existingLocations;
    }
    final url = Uri.parse(
      '${AppSecrets.googleMapApiUrl}/json?input=${Uri.encodeComponent(query)}'
          '&key=${AppSecrets.googleMapApiKey}&components=country:in',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {

      print("here is coming1");
      final jsonData = json.decode(response.body);
      final predictions = jsonData['predictions'] as List;

      final addresses =
      predictions.map((e) => e['description'] as String).toList();
      await _firebaseService.saveLocations(addresses);
      return addresses;
    } else {
      throw Exception("Failed to load suggestions: ${response.body}");
    }
  }
}
