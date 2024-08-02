import 'package:edventure/constants/images.dart';
import 'package:flutter/material.dart';
import '../utils/profile_avatar.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){},
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ProfileAvatar(image:AppImages.profile),
          SizedBox(width: 6.0,),
          Flexible(
            child: Text(
              'Arbin Shrestha' ,
                style : 
                  TextStyle(
                    fontSize: 16.0
                  ),
                  overflow: TextOverflow.ellipsis,
              ),
          )
        ],
      ),
    );
  }
}
