
import 'package:edventure/utils/custom_card.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final MessageModel message;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){

        },
        child: Icon(
          Icons.chat_sharp
        ),
      ),
      body: ListView(
        // itemCount: message.length,
        // itemBuilder: (context,index)=>CustomCard(),
        padding: EdgeInsets.all(8.0),
        children: [
          CustomCard(),
          CustomCard()
        ],
      ),
    );
  }
}