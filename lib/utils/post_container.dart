
import 'package:edventure/utils/post_stats.dart';
import 'package:edventure/utils/profile_avatar.dart';
import 'package:flutter/material.dart';

import '../constants/images.dart';

class PostContainer extends StatelessWidget {
  const PostContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        color: Colors.white,
        child: const Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PostHeader(),
                  SizedBox(
                    height: 7.0,
                  ),
                  Text('Hello this is Arbin shrestha' , style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16
                  ),),
                  SizedBox(
                    height: 10.0,
                  ),
                  PostStats(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostHeader extends StatelessWidget {
  const PostHeader({
    super.key, 
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const ProfileAvatar(
          image: AppImages.profile, 
        ),
        const SizedBox(width: 8.0,),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Arbin Shrestha' , 
                style: TextStyle(
                  fontWeight: FontWeight.w600
                ),
              ),
              Row(
                children: [
                  Text('5h ago ', style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12.0
                  ),),
                  Icon(
                    Icons.public,
                    color: Colors.grey[600],
                    size: 12.0,
                  ),
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}