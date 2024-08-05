import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  final String image;

  const ProfileAvatar({
    super.key, 
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: 24.0,
          backgroundColor: Colors.grey.shade100,
          child: CircleAvatar(
            radius: 24,
            backgroundColor: Colors.grey[200],
            child: ClipOval(
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                width: 42.0,
                height: 42.0,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
