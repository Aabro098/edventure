
import 'package:edventure/utils/post_stats.dart';
import 'package:edventure/utils/profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const PostHeader(),
                  const SizedBox(
                    height: 7.0,
                  ),
                  const Text('Hello this is Arbin shrestha' , 
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 100,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.profile),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const PostStats(),
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