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
