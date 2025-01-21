import 'package:edventure/Screens/Messenger/individual_chat.dart';
import 'package:edventure/Screens/Profile%20Screen/view_profile.dart';
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/user.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../utils/profile_avatar.dart';

class FriendCard extends StatefulWidget {
  final User user;
  final VoidCallback? onTap;

  const FriendCard({
    super.key,
    required this.user,
    this.onTap,
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
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.07),
              spreadRadius: 3,
              blurRadius: 7,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          leading: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ProfileViewScreen(userId: widget.user.id)));
            },
            child: ProfileAvatar(
              image: widget.user.profileImage.isNotEmpty
                  ? "$uri/${widget.user.profileImage}"
                  : '',
            ),
          ),
          title: InkWell(
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
          subtitle: Text(
            widget.user.bio,
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
              fontStyle: FontStyle.italic,
            ),
            overflow: TextOverflow.clip,
          ),
          trailing: InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => IndividualChat(user: widget.user)));
            },
            child: Icon(
              Bootstrap.messenger,
              size: 24.0,
              color: Colors.teal.shade300,
            ),
          ),
          contentPadding: const EdgeInsets.all(8.0),
        ),
      ),
    );
  }
}
