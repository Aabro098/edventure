import 'package:edventure/Widgets/stars.dart';
import 'package:edventure/Widgets/user_card.dart';
import 'package:edventure/constants/Colors/colors.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatefulWidget {
  final String senderId;
  final String description;
  final int rating;

  const ReviewCard({
    required this.senderId,
    required this.description,
    required this.rating,
    super.key,
  });

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start, 
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: UserCard(isNotification: false),
          ),
          const SizedBox(width: 5.0),
          Expanded(  // Added to prevent overflow
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.description,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                  overflow: TextOverflow.clip,
                ),
                const SizedBox(height: 5.0),
                Star(count: widget.rating)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
