import 'dart:async';
import 'dart:convert';
import 'package:edventure/constants/variable.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:edventure/Screens/Messenger/individual_chat.dart';
import 'package:edventure/Screens/Messenger/select_contact.dart';
import 'package:edventure/models/user_message.dart';
import 'package:edventure/models/user.dart';
import 'package:edventure/utils/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edventure/Providers/user_provider.dart';

class RecentChatScreen extends StatefulWidget {
  const RecentChatScreen({super.key});

  @override
  State<RecentChatScreen> createState() => _RecentChatScreenState();
}

class _RecentChatScreenState extends State<RecentChatScreen> {
  List<UserWithMessage> recentChats = [];
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;
  late io.Socket socket;
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = Provider.of<UserProvider>(context, listen: false).user.id;
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await initializeSocket();
      await loadInitialChats();
    } catch (e) {
      setState(() {
        hasError = true;
        errorMessage = 'Failed to initialize: $e';
      });
    }
  }

  Future<void> loadInitialChats() async {
    try {
      final chats = await fetchAllUsersWithMessages(context);
      if (mounted) {
        setState(() {
          recentChats = chats;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          hasError = true;
          errorMessage = 'Failed to load chats: $e';
          isLoading = false;
        });
      }
    }
  }

  Future<void> initializeSocket() async {
    try {
      socket = io.io(uri, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket.connect();
      
      socket.onConnect((_) {
        socket.emit('/test', currentUserId);
      });

      socket.on('message', (data) {
        if (data['sourceId'] != currentUserId) {
          _updateChatList(
            data['sourceId'],
            data['message'],
          );
        }
      });
    } catch (e) {
      throw Exception('Failed to initialize socket: $e');
    }
  }

  Future<User> fetchUserDetails(String userId) async {
    final url = '$uri/user/$userId';
    final response = await http.get(Uri.parse(url));
    
    if (response.statusCode == 200) {
      try {
        final jsonResponse = jsonDecode(response.body);
        return User.fromMap(jsonResponse);
      } catch (e) {
        throw Exception('Error parsing user data');
      }
    } else if (response.statusCode == 404) {
      throw Exception('User not found');
    } else {
      throw Exception('Failed to load user data');
    }
  }

  void _updateChatList(String otherUserId, String message) async {
    try {
      int existingIndex = recentChats.indexWhere(
        (chat) => chat.user.id == otherUserId
      );

      if (existingIndex != -1) {
        setState(() {
          UserWithMessage existingChat = recentChats[existingIndex];
          UserWithMessage updatedChat = UserWithMessage(
            user: existingChat.user,
            lastMessage: message,
            lastMessageTime: DateTime.now(),
          );
          
          recentChats.removeAt(existingIndex);
          recentChats.insert(0, updatedChat);
        });
      } else {
        final user = await fetchUserDetails(otherUserId);
        if (mounted) {
          setState(() {
            recentChats.insert(0, UserWithMessage(
              user: user,
              lastMessage: message,
              lastMessageTime: DateTime.now(),
            ));
          });
        }
      }
    } catch (e) {
      throw Exception('Error updating chat list: $e');
    }
  }

  void handleSentMessage(String targetId, String message) {
    socket.emit('message', {
      'sourceId': currentUserId,
      'targetId': targetId,
      'message': message,
      'type': 'source',
    });
    
    _updateChatList(targetId, message);
  }

  @override
  void dispose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (builder) => SelectContact()),
          ).then((_) => loadInitialChats()); 
        },
        child: const Icon(Icons.chat_sharp),
      ),
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (hasError) {
            return Center(child: Text(errorMessage ?? 'An error occurred'));
          } else if (recentChats.isEmpty) {
            return const Center(child: Text('No recent chats found.'));
          }
          
          return ListView.builder(
            itemCount: recentChats.length,
            itemBuilder: (context, index) {
              final chat = recentChats[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IndividualChat(
                        user: chat.user,
                      ),
                    ),
                  ).then((_) => loadInitialChats()); 
                },
                child: CustomCard(
                  user: chat.user,
                  lastMessage: chat.lastMessage,
                  lastMessageTime: chat.lastMessageTime,
                ),
              );
            },
          );
        },
      ),
    );
  }
}