import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String? image; 

  const ProfileAvatar({
    super.key,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: Colors.grey[300], 
      backgroundImage: image != null && image!.isNotEmpty
          ? NetworkImage(image!)
          : null,
      child: image == null || image!.isEmpty
          ? Icon(
              Icons.person,
              size: 32,
              color: Colors.grey[600],
            )
          : null,
    );
  }
}
