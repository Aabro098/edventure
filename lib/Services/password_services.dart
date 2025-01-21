import 'dart:convert';
import 'package:edventure/constants/variable.dart';
import 'package:http/http.dart' as http;

class PasswordResetService {
  Future<Map<String, dynamic>> sendResetCode(String email) async {
    try {
      final requestBody = json.encode({'email': email});

      final response = await http.post(
        Uri.parse('$uri/send-reset-code'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );

      try {
        final responseData = json.decode(response.body);

        if (response.statusCode == 200) {
          return {
            'success': true,
            'message': responseData['message'],
            'email': responseData['email'],
          };
        } else {
          return {
            'success': false,
            'message': responseData['message'] ?? 'Failed to send reset code',
            'statusCode': response.statusCode,
          };
        }
      } catch (parseError) {
        return {
          'success': false,
          'message': 'Invalid response format',
          'error': parseError.toString(),
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred',
        'error': e.toString(),
      };
    }
  }

  Future<Map<String, dynamic>> verifyCode(String email, String code) async {
    try {
      final response = await http.post(
        Uri.parse('$uri/verify-code'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'email': email,
          'code': code,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': responseData['message'],
        };
      } else {
        return {
          'success': false,
          'message': responseData['message'] ?? 'Failed to verify code',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error occurred',
      };
    }
  }
}
