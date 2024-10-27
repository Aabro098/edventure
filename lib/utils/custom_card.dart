
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:edventure/models/user.dart';

class CustomCard extends StatelessWidget {
  final User user;
  final String lastMessage;
  final DateTime lastMessageTime;
  const CustomCard({
    super.key,
    required this.user, 
    required this.lastMessage, 
    required this.lastMessageTime,
  });

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('hh:mm a').format(lastMessageTime);
    return ListTile(
      leading: CircleAvatar(
        radius : 25,
        backgroundImage: user.profileImage.isNotEmpty
            ? NetworkImage(user.profileImage) 
            : null, 
        child: user.profileImage.isEmpty
            ? Icon(Icons.person, size: 30)
            : null,
      ),
      title: Text(
        user.name,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
      ),  
      subtitle: Text(lastMessage,
        style: TextStyle(
          fontSize: 13
        ),
      ),
      trailing: Text(formattedTime),
    );
  }
}
