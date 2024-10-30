import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OwnMessageCard extends StatelessWidget {
  final String message;
  final String time; 

  const OwnMessageCard({super.key, required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Colors.lime.shade100,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 30,
                  top: 5,
                  bottom: 20,
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                bottom: 4,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      _getTimeAgo(time),
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Icon(
                      Icons.done_all,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReplyCard extends StatelessWidget {
  final String message;
  final String time; 

  const ReplyCard({super.key, required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: Colors.lightGreen.shade100,
          margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 8,
                  right: 60,
                  top: 5,
                  bottom: 10,
                ),
                child: Text(
                  message,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 2,
                child: Text(
                  _getTimeAgo(time),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _getTimeAgo(String timestamp) {
  try {
    final DateTime messageTime = DateTime.parse(timestamp).toLocal();
    final DateTime now = DateTime.now();
    final Duration diff = now.difference(messageTime);

    if (diff.inMinutes < 1) {
      return 'Just now';
    }
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes} mins ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours} hours ago';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays} days ago';
    }
    if (messageTime.year == now.year) {
      return DateFormat('MMM d, HH:mm').format(messageTime);
    }
    return DateFormat('MMM d, yyyy').format(messageTime);
  } catch (e) {
    try {
      final DateTime now = DateTime.now();
      final DateTime messageTimeUtc = DateTime.utc(
        now.year,
        now.month,
        now.day,
        int.parse(timestamp.split(':')[0]),
        int.parse(timestamp.split(':')[1]),
      );

      final DateTime messageTimeLocal = messageTimeUtc.toLocal();
      final Duration diff = now.difference(messageTimeLocal);

      if (diff.inMinutes < 1) return 'Just now';
      if (diff.inMinutes < 60) return '${diff.inMinutes} mins ago';
      if (diff.inHours < 24) return '${diff.inHours} hours ago';

      return DateFormat('HH:mm').format(messageTimeLocal);
    } catch (e) {
      return timestamp;
    }
  }
}