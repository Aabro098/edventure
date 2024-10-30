
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/user.dart';
import 'package:flutter/material.dart';
import '../utils/profile_avatar.dart';

class UserCard extends StatelessWidget {
  final bool? isNotification;
  final User user;
  const UserCard({
    super.key,
    this.isNotification, 
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileAvatar(image: '$uri/${user.profileImage}'),
          const SizedBox(width: 8.0),
          Flexible(
            child:Text(
              user.name,
              style: TextStyle(
                fontSize: isNotification!=null ? 14.0 : 18.0,
                fontWeight: FontWeight.normal
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

