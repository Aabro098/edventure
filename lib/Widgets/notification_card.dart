
import 'package:flutter/material.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        width: double.infinity,
        height: 100.0,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 7.0,
              offset: const Offset(0, 2)
            )
          ]
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello this is the Notification model.\nThis is where i have been testing the flutter application.',
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 14.0,
              ),
              overflow: TextOverflow.clip,
            ),
            SizedBox(
              height: 5.0,
            ),
            Positioned(
              left: 0.0,
              bottom: 0.0,
              child: Text('5h ago',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
