import 'package:flutter/material.dart';

import 'package:edventure/constants/images.dart';

import '../utils/profile_avatar.dart';

class UserCard extends StatelessWidget {
  final bool? notification;
  const UserCard({
    super.key,
    this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ProfileAvatar(image: AppImages.profile),
          const SizedBox(width: 6.0),
          if (!(notification ?? false))
            const Flexible(
              child: Text(
                'Arbin Shrestha',
                style: TextStyle(
                  fontSize: 16.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
