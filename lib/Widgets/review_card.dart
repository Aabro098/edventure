import 'package:edventure/Services/api_services.dart'; 
import 'package:edventure/Widgets/stars.dart';
import 'package:edventure/Widgets/user_card.dart';
import 'package:edventure/constants/colors.dart';
import 'package:edventure/models/user.dart'; 
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
  late Future<User> futureUser;

  @override
  void initState() {
    super.initState();
    futureUser = ApiService().fetchUserData(widget.senderId);
  }

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FutureBuilder<User>(
              future: futureUser,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); 
                } else if (snapshot.hasError) {
                  return const Icon(Icons.error, color: Colors.red);
                } else if (snapshot.hasData) {
                  final user = snapshot.data!;
                  return UserCard(
                    user: user, 
                  );
                } else {
                  return const Icon(Icons.error, color: Colors.red); 
                }
              },
            ),
          ),
          const SizedBox(width: 5.0),
          Expanded( 
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
