import 'package:edventure/Widgets/stars.dart';
import 'package:edventure/Widgets/user_card.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  final bool? review;
  const NotificationCard({
    super.key, 
    this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 7.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(
              child: UserCard(notification: true)
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello this is the Notification model.\nThis is where I have been testing the flutter application.',
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 14.0,
                ),
                overflow: TextOverflow.clip,
              ),
              const SizedBox(
                height: 5.0,
              ),
              review ?? false 
              ? const Star(count : 3)
              : const Text(
                  '5h ago',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }
}
