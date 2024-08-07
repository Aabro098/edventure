import 'package:edventure/constants/images.dart';
import 'package:edventure/utils/text_button.dart';
import 'package:flutter/material.dart';
import 'profile_avatar.dart';

class CreatePostContainer extends StatelessWidget {
  const CreatePostContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const ProfileAvatar(
                    image: AppImages.profile,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){},
                      child: RichText(
                        text: TextSpan(
                          text: "What's on your mind?",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const VerticalDivider(width: 15),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TTextButton(
                  iconData: Icons.live_tv,
                  onPressed: () {},
                  labelText: 'Live',
                  color: Colors.red,
                ),
                const VerticalDivider(width: 8),
                TTextButton(
                  iconData: Icons.photo,
                  onPressed: () {},
                  labelText: 'Photo',
                  color: Colors.green,
                ),
                const VerticalDivider(width: 8),
                TTextButton(
                  iconData: Icons.group,
                  onPressed: () {},
                  labelText: 'Group',
                  color: Colors.purple,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
