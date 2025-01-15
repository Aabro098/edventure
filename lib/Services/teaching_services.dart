import 'dart:convert';
import 'package:edventure/constants/variable.dart';
import 'package:http/http.dart' as http;

class TeachingService {
  static Future<Map<String, dynamic>> addTeachingAddress(String userId, String address) async {
    final url = Uri.parse('$uri/addTeachingAddress');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'address': address}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to add teaching address: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> deleteTeachingAddress(String userId, String address) async {
    final url = Uri.parse('$uri/deleteTeachingAddress');
    final response = await http.delete(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'address': address}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete teaching address: ${response.body}');
    }
  }

  static Future<Map<String, dynamic>> getVerifiedUsers(String userId, String address) async {
    final url = Uri.parse('$uri/getVerifiedUsers');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userId': userId, 'address': address}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch verified users: ${response.body}');
    }
  }

}
