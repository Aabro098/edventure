
import 'package:edventure/Screens/Messenger/individual_chat.dart';
import 'package:edventure/Screens/Messenger/select_contact.dart';
import 'package:edventure/Services/api_services.dart';
import 'package:edventure/models/user.dart';
import 'package:edventure/utils/custom_card.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = ApiService().fetchAllUsers(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (builder)=>SelectContact()
            )
          );
        },
        child: Icon(
          Icons.chat_sharp
        ),
      ),
      body: FutureBuilder<List<User>>(
      future: futureUsers,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No users found.'));
        } else {
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context , index){
              final user = users[index];
              return InkWell(
                onTap: (){
                  Navigator.push(
                    context, 
                    MaterialPageRoute(
                      builder : (context)=>IndividualChat(user: user)
                    )
                  );
                },
                child : CustomCard(user: user),
                );  
              },
            );
          }
        }
      )
    );
  }
}