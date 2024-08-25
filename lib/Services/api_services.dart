import 'dart:convert';
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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

  Future<List<User>> searchUsers(String query) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      final headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        if (token != null) 'x-auth-token': token,
      };

      final response = await http.get(
        Uri.parse('$uri/search?query=${Uri.encodeComponent(query)}'),
        headers: headers,
      );


      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        return data.map((userJson) {
          if (userJson is Map<String, dynamic>) {
            return User.fromMap(userJson);
          } else {
            throw Exception('Unexpected data format');
          }
        }).toList();
            } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error occurred while searching for users: $e');
    }
  }
}
