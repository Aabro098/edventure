import 'package:edventure/Screens/Messenger/individual_chat.dart';
import 'package:edventure/Screens/Messenger/select_contact.dart';
import 'package:edventure/models/user_message.dart';
import 'package:edventure/utils/custom_card.dart';
import 'package:flutter/material.dart';

class RecentChatScreen extends StatefulWidget {
  const RecentChatScreen({super.key});

  @override
  State<RecentChatScreen> createState() => _RecentChatScreenState();
}

class _RecentChatScreenState extends State<RecentChatScreen> {
  late Future<List<UserWithMessage>> futureUsersWithMessages;

  @override
  void initState() {
    super.initState();
    futureUsersWithMessages = fetchAllUsersWithMessages(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (builder) => SelectContact()),
          );
        },
        child: Icon(Icons.chat_sharp),
      ),
      body: FutureBuilder<List<UserWithMessage>>(
        future: futureUsersWithMessages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No recent chats found.'));
          } else {
            final recentChats = snapshot.data!;
            return ListView.builder(
              itemCount: recentChats.length,
              itemBuilder: (context, index) {
                final chat = recentChats[index];
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => IndividualChat(user: chat.user),
                      ),
                    );
                  },
                  child: CustomCard(
                    user: chat.user,
                    lastMessage: chat.lastMessage,
                    lastMessageTime: chat.lastMessageTime,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
