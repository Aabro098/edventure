import 'dart:convert';
import 'package:http/http.dart' as http;

class MapService {
  final String baseUrl;

  MapService(this.baseUrl);

  Future<Map<String, dynamic>> searchLocation(String query) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/places/autocomplete?input=$query'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load location data');
      }
    } catch (e) {
      throw Exception('Error searching for location: $e');
    }
  }

  Future<Map<String, dynamic>> getPlaceDetails(String placeId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/places/details?place_id=$placeId'));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load place details');
      }
    } catch (e) {
      throw Exception('Error getting place details: $e');
    }
  }
}
