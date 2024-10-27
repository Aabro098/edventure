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
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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
                  style: TextStyle(
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
                    SizedBox(width: 5),
                    Icon(
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
          margin: EdgeInsets.symmetric(horizontal: 25, vertical: 5),
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
                  style: TextStyle(
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

String _getTimeAgo(String time) {
  final DateTime now = DateTime.now();
  final DateTime messageTimeUtc = DateTime.utc(
    now.year,
    now.month,
    now.day,
    int.parse(time.split(':')[0]),
    int.parse(time.split(':')[1]),
  );

  final DateTime messageTimeLocal = messageTimeUtc.toLocal();
  Duration diff = DateTime.now().difference(messageTimeLocal);

  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} mins ago';
  if (diff.inHours < 24) return '${diff.inHours} hours ago';

  return DateFormat('yyyy-MM-dd').format(messageTimeLocal); 
}