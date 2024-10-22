import 'package:edventure/Screens/Messenger/individual_chat.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatefulWidget {
  const CustomCard({super.key});

  @override
  State<CustomCard> createState() => _CustomCardState();
}

class _CustomCardState extends State<CustomCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder : (context)=>IndividualChat()
          )
        );
      },
      child: ListTile(
        leading: CircleAvatar(
          radius : 25,
          child: Icon(
            Icons.person
          ),
        ),
        title: Text('Arbin Shrestha',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold
          ),
        ),
        subtitle: Text('Arbin has messaged you',
          style: TextStyle(
            fontSize: 13
          ),
        ),
        trailing: Text('6:00 PM'),
      ),
    );
  }
}