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
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                const ProfileAvatar(
                  image: AppImages.profile, // Pass the path as a String
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                      hintText: "What's on your mind ?",
                    ),
                  ),
                ),
                Divider(height: 15, thickness: 1, color: Colors.grey[200])
              ],
            ),
            const SizedBox(height: 8,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TTextButton(
                  iconData: Icons.live_tv,          
                  onPressed: () {}, 
                  labelText: 'Live', 
                  color: Colors.red, 
                ),
                const VerticalDivider(width: 8,),
                TTextButton(
                  iconData: Icons.photo, 
                  onPressed: () {}, 
                  labelText: 'Photo', 
                  color: Colors.green,
                ),
                const VerticalDivider(width: 8,),
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
