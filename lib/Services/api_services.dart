import 'dart:convert';
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  Future<User> fetchUserData(String userId) async {
      final url = '$uri/user/$userId'; 
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
          try {
              final jsonResponse = jsonDecode(response.body);
              return User.fromMap(jsonResponse);
          } catch (e) {
              throw Exception('Error parsing user data');
          }
      } else if (response.statusCode == 404) {
          throw Exception('User not found');
      } else {
          throw Exception('Failed to load user data');
      }
  }

  Future<List<User>> searchUsers(BuildContext context, String query , user) async {
    try {
      
      final response = await http.get(
        Uri.parse('$uri/search?query=${Uri.encodeComponent(query)}'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
          .where((userJson) => userJson is Map<String, dynamic> && userJson['id'] != user.id)
          .map<User>((userJson) => User.fromMap(userJson))
          .toList();
      } else {
        throw Exception('Failed to load users. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while searching for users: $e');
    }
  }


  Future<User> toggleAvailability(String token) async {
    final response = await http.put(
      Uri.parse('$uri/api/toggle-availability'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-auth-token': token,
      },
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      return User.fromJson(response.body);
    } else {
      throw Exception('Failed to toggle availability');
    }
  }
}
