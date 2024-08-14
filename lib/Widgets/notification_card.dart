import 'package:edventure/Widgets/stars.dart';
import 'package:edventure/Widgets/user_card.dart';
import 'package:edventure/constants/Colors/colors.dart';
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
      width: review == true ? 400 : null,
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
                if (review ?? false) 
                  const Text(
                    'Arbin Shrestha',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (review ?? false) 
                  const SizedBox(height: 5.0),
                const Text(
                  'Aryan Shrestha wants to send you a message.',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14.0,
                  ),
                  overflow: TextOverflow.visible,
                  maxLines: 4, 
                ),
                const SizedBox(height: 5.0),
                if (review ?? false) 
                  const Star(count: 3),
                if (review == null || !(review ?? false)) 
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
