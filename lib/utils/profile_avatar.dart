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
      radius: 20,
      backgroundColor: Colors.grey[500],
      backgroundImage:
          image != null && image!.isNotEmpty ? NetworkImage(image!) : null,
      child: (image == null || image!.isEmpty)
          ? Icon(
              Icons.person,
              size: 24,
              color: Colors.white,
            )
          : null,
    );
  }
}
