import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Services/api_services.dart';
import 'package:edventure/Widgets/stars.dart';
import 'package:edventure/constants/colors.dart';
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReviewCard extends StatefulWidget {
  final String reviewId;
  final String senderId;
  final String description;
  final int rating;
  final String currentUser;
  final String profileUser;

  const ReviewCard({
    super.key,
    required this.reviewId,
    required this.senderId,
    required this.description,
    required this.rating,
    required this.currentUser,
    required this.profileUser,
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
                radius: 25,
                backgroundImage: user.profileImage.isNotEmpty
                    ? NetworkImage('$uri/${user.profileImage}')
                    : null,
                backgroundColor: Colors.grey.shade400,
                child: user.profileImage.isEmpty
                    ? const Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.white,
                      )
                    : null,
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
                      onPressed: () async {
                        try {
                          await Provider.of<UserProvider>(context,
                                  listen: false)
                              .deleteReview(
                            reviewId: widget.reviewId,
                            senderId: widget.senderId,
                            rating: widget.rating,
                            profileUser: widget.profileUser,
                          );
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Review deleted successfully')),
                          );
                        } catch (e) {
                          // ignore: use_build_context_synchronously
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.toString())),
                          );
                        }
                      },
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
