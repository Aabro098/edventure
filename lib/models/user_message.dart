import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/user.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserWithMessage {
  final User user;
  final String lastMessage;
  final DateTime lastMessageTime;
  final bool isLastMessageFromMe;

  UserWithMessage({
    required this.user,
    required this.lastMessage,
    required this.lastMessageTime,
    required this.isLastMessageFromMe,
  });

  factory UserWithMessage.fromJson(Map<String, dynamic> json) {
    return UserWithMessage(
      user: User.fromMap(json['user']),
      lastMessage: json['lastMessage'] ?? '',
      lastMessageTime: DateTime.parse(json['lastMessageTime'] ?? DateTime.now().toIso8601String()),
      isLastMessageFromMe: json['isLastMessageFromMe'] ?? false,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'lastMessage': lastMessage,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'isLastMessageFromMe': isLastMessageFromMe,
    };
  }
}

Future<List<UserWithMessage>> fetchAllUsersWithMessages(BuildContext context) async {
  try {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    
    final response = await http.get(Uri.parse('$uri/recent-chats/${user.id}'));
    
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      final List<UserWithMessage> usersWithMessages = data
          .map<UserWithMessage>((json) => UserWithMessage.fromJson(json))
          .toList();

      usersWithMessages.sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));

      return usersWithMessages;
    } else {
      throw Exception('Failed to load users with recent messages. Status code: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Error occurred while fetching users with messages: $e');
  }
}
