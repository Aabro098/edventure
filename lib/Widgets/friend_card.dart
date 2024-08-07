import 'package:flutter/material.dart';
import 'package:edventure/constants/images.dart';
import '../utils/profile_avatar.dart';

class FriendCard extends StatelessWidget {
  const FriendCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
              child: const ProfileAvatar(
                image: AppImages.profile,
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
                    child: const Text(
                      'Arbin Shrestha',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  const Text(
                    'Those who do not know pain will never understand true peace.',
                    style: TextStyle(
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
              child: const Icon(
                Icons.message,
                size: 24.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
