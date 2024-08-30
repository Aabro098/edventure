import 'package:edventure/Widgets/stars.dart';
import 'package:edventure/Widgets/user_card.dart';
import 'package:edventure/constants/Colors/colors.dart';
import 'package:edventure/models/notification.dart';
import 'package:flutter/material.dart';

class NotificationCard extends StatefulWidget {
  final bool? review;
  final NotificationModel? notification;
  const NotificationCard({
    super.key, 
    this.review, 
    this.notification,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.review == true ? 400 : null,
      decoration: BoxDecoration(
        color: TAppColor.getRandomColor(),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
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
              child: UserCard(notification: true),
            ),
          ),
          Expanded( 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.review ?? false) 
                  const Text(
                    'Arbin Shrestha',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (widget.review ?? false) 
                  const SizedBox(height: 5.0),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: widget.notification?.senderId ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: Colors.black, 
                        ),
                      ),
                      TextSpan(
                        text: widget.notification?.message ?? '',
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14.0,
                          color: Colors.black, 
                        ),
                      ),
                    ],
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.visible,
                ),
                const SizedBox(height: 5.0),
                if (widget.review ?? false) 
                  const Star(count: 3),
                if (widget.review == null || !(widget.review ?? false)) 
                  const Text(
                    '5h ago',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
