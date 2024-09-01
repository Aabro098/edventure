import 'dart:convert';
import 'package:edventure/models/notification.dart';
import 'package:http/http.dart' as http;
import 'package:edventure/constants/variable.dart';

class NotificationServices {
  Future<void> addNotification({
    required String userId,
    required String senderId, 
    required String message,
    required bool responseStatus,
    required bool notificationStatus,
  }) async {
    final response = await http.post(
      Uri.parse('$uri/user/$userId/add_notifications'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'senderId': senderId, 
        'message': message,
        'responseStatus': responseStatus,
        'notificationStatus': notificationStatus,
        'dateTime': DateTime.now().millisecondsSinceEpoch,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add notification');
    }
  }


  Future<List<NotificationModel>> fetchNotifications(String userId) async {
    try {
      final response = await http.get(Uri.parse('$uri/notifications/$userId'));

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => NotificationModel.fromMap(data)).toList();
      } else {
        throw Exception('Failed to load notifications. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load notifications: $e');
    }
  }

  Future<void> updateNotificationStatus(String notificationId, bool status) async {
    final response = await http.patch(
      Uri.parse('$uri/notifications/$notificationId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'notificationStatus': status}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update notification status');
    }
  }
}
