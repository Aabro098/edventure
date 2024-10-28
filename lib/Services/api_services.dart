import 'dart:convert';
import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

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

  Future<List<User>> searchUsers(BuildContext context, String query) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;
      final response = await http.get(
        Uri.parse('$uri/search?query=${Uri.encodeComponent(query)}&userId=${user.id}'),
      );


      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data
          .where((userJson) => userJson is Map<String, dynamic> && userJson['_id'] != user.id)
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
    try {

      final response = await http.put(
        Uri.parse('$uri/api/toggle-availability'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = jsonDecode(response.body);
        // Preserve the token in the response data
        responseData['token'] = token;  // Add this line to preserve the token
        return User.fromMap(responseData);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Server returned ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to toggle availability: $e');
    }
  }

  Future<List<User>> fetchAllUsers(BuildContext context) async {
    try {
      final user = Provider.of<UserProvider>(context, listen: false).user;

      final response = await http.get(Uri.parse('$uri/users?userId=${user.id}'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map<User>((userJson) => User.fromMap(userJson)).toList();
      } else {
        throw Exception('Failed to load users. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching users: $e');
    }
  }
}
