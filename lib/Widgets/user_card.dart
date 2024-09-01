import 'package:edventure/Providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:edventure/constants/images.dart';
import 'package:provider/provider.dart';
import '../utils/profile_avatar.dart';

class UserCard extends StatelessWidget {
  final bool? isNotification;
  const UserCard({
    super.key,
    this.isNotification,
  });

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return InkWell(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ProfileAvatar(image: AppImages.profile),
          const SizedBox(width: 6.0),
          if (!(isNotification ?? false))
            Flexible(
              child: Text(
                user.name,
                style: const TextStyle(
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
