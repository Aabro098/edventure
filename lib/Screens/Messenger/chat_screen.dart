import 'dart:async';
import 'package:edventure/Services/api_services.dart';
import 'package:edventure/constants/variable.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:edventure/Screens/Messenger/individual_chat.dart';
import 'package:edventure/Screens/Messenger/select_contact.dart';
import 'package:edventure/models/user_message.dart';
import 'package:edventure/utils/custom_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edventure/Providers/user_provider.dart';

class RecentChatScreen extends StatefulWidget {
  const RecentChatScreen({super.key});

  @override
  State<RecentChatScreen> createState() => _RecentChatScreenState();
}

class _RecentChatScreenState extends State<RecentChatScreen> with WidgetsBindingObserver {
  List<UserWithMessage> recentChats = [];
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;
  late io.Socket socket;
  late String currentUserId;
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    currentUserId = Provider.of<UserProvider>(context, listen: false).user.id;
    _initialize();
    _startPeriodicRefresh();
  }

  void _startPeriodicRefresh() {
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        loadInitialChats();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      loadInitialChats();
    }
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
          hasError = false;
          errorMessage = null;
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
            isLastMessageFromMe: false,
          );
        } else {
          _updateChatList(
            data['targetId'],
            data['message'],
            isLastMessageFromMe: true, 
          );
        }
      });

      socket.on('disconnect', (_) async {
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          socket.connect();
        }
      });

    } catch (e) {
      throw Exception('Failed to initialize socket: $e');
    }
  }

  Future<void> navigateToChat(UserWithMessage chat) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IndividualChat(
          user: chat.user,
          onMessageSent: () {
            _updateChatList(
              chat.user.id,
              "New message",
              isLastMessageFromMe: true, 
            );
            loadInitialChats();
          },
        ),
      ),
    );

    if (mounted) {
      await loadInitialChats();
    }
  }

  void _updateChatList(String otherUserId, String message , {required bool isLastMessageFromMe}) async {
    
    try {
      int existingIndex = recentChats.indexWhere(
        (chat) => chat.user.id == otherUserId
      );

      if (existingIndex != -1) {
        if (mounted) {
          setState(() {
            UserWithMessage existingChat = recentChats[existingIndex];
            UserWithMessage updatedChat = UserWithMessage(
              user: existingChat.user,
              lastMessage: message,
              lastMessageTime: DateTime.now(), 
              isLastMessageFromMe: isLastMessageFromMe,
            );
            
            recentChats.removeAt(existingIndex);
            recentChats.insert(0, updatedChat);
          });
        }
      } else {
        final user = await ApiService().fetchUserData(otherUserId);
        if (mounted) {
          setState(() {
            recentChats.insert(0, UserWithMessage(
              user: user,
              lastMessage: message,
              lastMessageTime: DateTime.now(), 
              isLastMessageFromMe: isLastMessageFromMe,
            ));
          });
        }
      }
    } catch (e) {
      debugPrint('Error updating chat list: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (builder) => SelectContact()),
          );
          if (mounted) {
            await loadInitialChats();
          }
        },
        child: const Icon(Icons.chat_sharp),
      ),
      body: RefreshIndicator(
        onRefresh: loadInitialChats,
        child: Builder(
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
                  onTap: () => navigateToChat(chat),
                  child: CustomCard(
                    user: chat.user,
                    lastMessage: chat.lastMessage,
                    lastMessageTime: chat.lastMessageTime,
                    isLastMessageFromMe : chat.isLastMessageFromMe
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}