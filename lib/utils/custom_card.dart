
import 'package:edventure/models/user.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final User user;
  const CustomCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius : 25,
        backgroundImage: user.profileImage.isNotEmpty
            ? NetworkImage(user.profileImage) 
            : null, 
        child: user.profileImage.isEmpty
            ? Icon(Icons.person, size: 30)
            : null,
      ),
      title: Text(
        user.name,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold
        ),
      ),  
      subtitle: Text('${user.name} has messaged you',
        style: TextStyle(
          fontSize: 13
        ),
      ),
      trailing: Text('6:00 PM'),
    );
  }
}