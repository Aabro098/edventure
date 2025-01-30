import 'dart:convert';
import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/classes_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class InstitutionService {
  Future<List<Institution>> searchClasses(String type, String query) async {
    final url = Uri.parse('$baseUrl/api/ins/search/$type/$query');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['success']) {
        List<Institution> institutions = (data['data'] as List)
            .map((json) => Institution.fromJson(json))
            .toList();
        return institutions;
      } else {
        throw Exception('Failed to load data: ${data['message']}');
      }
    } else {
      throw Exception(
          'Failed to load data with status code: ${response.statusCode}');
    }
  }

  static Future enrollUserInClass(
      String userId, String classId, BuildContext context) async {
    final String url = '$uri/enroll';

    final Map<String, dynamic> requestBody = {
      'userId': userId,
      'classId': classId,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );
      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        // ignore: use_build_context_synchronously
        userProvider.addEnrollClass(classId, context);
        return {'success': true};
      } else {
        throw Exception('Failed to enroll user.');
      }
    } catch (e) {
      throw Exception('Failed to enroll user');
    }
  }

  Future<List<Institution>> searchClassesById(List<String> classIds) async {
    final String classIdQuery = classIds.join(',');
    final url = Uri.parse('$baseUrl/api/ins/searchByClassId/$classIdQuery');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      if (data['success']) {
        List<Institution> institutions = (data['data'] as List)
            .map((json) => Institution.fromJson(json))
            .toList();
        return institutions;
      } else {
        throw Exception('Failed to load data: ${data['message']}');
      }
    } else {
      throw Exception(
          'Failed to load data with status code: ${response.statusCode}');
    }
  }
}
