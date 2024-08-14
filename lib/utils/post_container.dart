import 'package:edventure/utils/post_stats.dart';
import 'package:edventure/utils/profile_avatar.dart';
import 'package:edventure/utils/text_button.dart';
import 'package:flutter/material.dart';
import '../constants/images.dart';

class PostContainer extends StatefulWidget {
  const PostContainer({
    super.key,
  });

  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 3),
            )
          ],
        ),
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
                  const Text(
                    'Hello this is Arbin Shrestha',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 400,
                    width: 600,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(AppImages.profile),
                        fit: BoxFit.contain,
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

class PostHeader extends StatefulWidget {
  const PostHeader({
    super.key,
  });

  @override
  State<PostHeader> createState() => _PostHeaderState();
}

class _PostHeaderState extends State<PostHeader> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const ProfileAvatar(
              image: AppImages.profile,
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Arbin Shrestha',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Text(
                        '5h ago',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12.0,
                        ),
                      ),
                      Icon(
                        Icons.public,
                        color: Colors.grey[600],
                        size: 12.0,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 12.0),
              child: TextButton(
                onPressed: () {},  
                child: TTextButton(
                  iconData: Icons.flag_outlined, 
                  onPressed: (){}, 
                  labelText: 'Report', 
                  color: Colors.red
                ),
              ),
            ),
          ],
        ),  
      ],
    );
  }
}
