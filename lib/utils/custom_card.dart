import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
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

  String getRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(lastMessageTime);
    
    if (difference.inHours < 24) {
      return timeago.format(lastMessageTime, locale: 'en_short');  
    }
    else if (difference.inDays == 1) {
      return 'Yesterday';
    }
    else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }
    else {
      return '${lastMessageTime.day}/${lastMessageTime.month}/${lastMessageTime.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    final relativeTime = getRelativeTime();
    
    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundImage: user.profileImage.isNotEmpty
            ? NetworkImage(user.profileImage)
            : null,
        child: user.profileImage.isEmpty
            ? const Icon(Icons.person, size: 30)
            : null,
      ),
      title: Text(
        user.name,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        lastMessage,
        style: const TextStyle(
          fontSize: 13,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Text(
        relativeTime,
        style: TextStyle(
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}