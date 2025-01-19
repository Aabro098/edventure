import 'package:edventure/Services/api_services.dart';
import 'package:edventure/Widgets/stars.dart';
import 'package:edventure/constants/colors.dart';
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/user.dart';
import 'package:flutter/material.dart';

class ReviewCard extends StatefulWidget {
  final String senderId;
  final String description;
  final int rating;
  final String currentUser;

  const ReviewCard({
    required this.senderId,
    required this.description,
    required this.rating,
    required this.currentUser,
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
      child: FutureBuilder<User>(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Icon(Icons.error, color: Colors.red);
          } else if (snapshot.hasData) {
            final user = snapshot.data!;

            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundImage: NetworkImage('$uri/${user.profileImage}'),
                radius: 25,
              ),
              title: Text(
                user.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 5.0),
                  Star(count: widget.rating)
                ],
              ),
              trailing: widget.senderId == widget.currentUser
                  ? IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {},
                    )
                  : null,
            );
          } else {
            return const Icon(Icons.error, color: Colors.red);
          }
        },
      ),
    );
  }
}
