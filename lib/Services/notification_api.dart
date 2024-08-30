import 'dart:convert';
import 'package:edventure/models/notification.dart';
import 'package:http/http.dart' as http;
import 'package:edventure/constants/variable.dart';

class NotificationServices{
  Future<void> addNotification({
    required String userId,
    required String senderId,
    required String message,
    }) async {
    final String apiUrl = '$uri/user/$userId/add_notifications';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'senderId': senderId,
          'message': message,
        }),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add notification: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

    Future<List<NotificationModel>> fetchNotifications(String userId) async {
      final response = await http.get(Uri.parse('$uri/notifications/$userId'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => NotificationModel.fromMap(data)).toList();
      } else {
        throw Exception('Failed to load notifications');
      }
    }
  }