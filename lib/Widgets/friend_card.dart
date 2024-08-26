import 'package:edventure/models/user.dart';
import 'package:flutter/material.dart';
import '../utils/profile_avatar.dart';

class FriendCard extends StatefulWidget {
  final bool suggested;
  final User user; 
  final VoidCallback?onTap;

  const FriendCard({
    super.key,
    required this.suggested, 
    required this.user, 
    this.onTap
  });

  @override
  State<FriendCard> createState() => _FriendCardState();
}

class _FriendCardState extends State<FriendCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                child: ProfileAvatar(
                  image: widget.user.profileImage.isNotEmpty 
                      ? widget.user.profileImage
                      : '', 
                ),
              ),
            ),
            const SizedBox(width: 6.0),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {},
                      child: Text(
                        widget.user.name, 
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      widget.user.bio,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.normal,
                        fontStyle: FontStyle.italic,
                      ),
                      overflow: TextOverflow.clip,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              width: 50.0,
              height: 50.0,
              child: InkWell(
                onTap: () {},
                child: Icon(
                  widget.suggested 
                      ? Icons.notification_important
                      : Icons.message,
                  size: 24.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
