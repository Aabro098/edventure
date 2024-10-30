import 'dart:async';
import 'dart:convert';
import 'package:edventure/constants/variable.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/models/message.dart';
import 'package:edventure/utils/message_card.dart';
import 'package:edventure/Widgets/user_card.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:edventure/models/user.dart';

class IndividualChat extends StatefulWidget {
  final User user;
  final VoidCallback? onMessageSent;

  const IndividualChat({
    super.key, 
    required this.user,
    this.onMessageSent,
  });

  @override
  IndividualChatState createState() => IndividualChatState();
}

class IndividualChatState extends State<IndividualChat> with WidgetsBindingObserver {
  late io.Socket socket;
  bool show = false;
  FocusNode focusNode = FocusNode();
  final TextEditingController messageController = TextEditingController();
  List<MessageModel> messages = [];
  ScrollController scrollController = ScrollController();
  late String currentUserId;
  bool isConnected = false;
  Timer? _reconnectionTimer;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    currentUserId = Provider.of<UserProvider>(context, listen: false).user.id;
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
    _initialize();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!isConnected) {
        connect();
      }
      fetchMessages();
    } else if (state == AppLifecycleState.paused) {
      socket.disconnect();
      _reconnectionTimer?.cancel();
    }
  }

  Future<void> _initialize() async {
    try {
      await connect();
      await fetchMessages();
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to initialize chat: $e';
      });
    }
  }

  Future<void> fetchMessages() async {
    String url = '$uri/messages/$currentUserId/${widget.user.id}';
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> jsonMessages = json.decode(response.body);
        List<MessageModel> fetchedMessages = jsonMessages.map((json) {
          return MessageModel(
            sourceId: json['sourceId'],
            targetId: json['targetId'],
            message: json['message'],
            time: formatMessageTime(json['timestamp'] ?? json['time']),
            type: json['sourceId'] == currentUserId ? 'source' : 'destination'
          );
        }).toList();

        if (mounted) {
          setState(() {
            messages = fetchedMessages.reversed.toList();
            _error = null;
          });
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToBottom();
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = 'Error fetching messages: $error';
        });
      }
    }
  }

  Future<void> connect() async {
    socket = io.io(
      uri,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();
    socket.emit("/test", currentUserId);

    socket.onConnect((_) {
      setState(() {
        isConnected = true;
      });
      _reconnectionTimer?.cancel();
    });

    socket.onDisconnect((_) {
      setState(() {
        isConnected = false;
      });
      _startReconnectionTimer();
    });

    socket.on("message", (msg) {
      if (mounted) {
        MessageModel messageModel = MessageModel(
          sourceId: msg["sourceId"],
          targetId: msg["targetId"],
          message: msg["message"],
          time: DateTime.now().toString().substring(11, 16),
          type: msg["sourceId"] == currentUserId ? 'source' : 'destination'
        );
        
        setState(() {
          messages.insert(0, messageModel);
        });
        scrollToBottom();
        
        if (msg["sourceId"] != currentUserId) {
          widget.onMessageSent?.call();
        }
      }
    });
  }

  void _startReconnectionTimer() {
    _reconnectionTimer?.cancel();
    _reconnectionTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!isConnected) {
        socket.connect();
      } else {
        timer.cancel();
      }
    });
  }

  void sendMessage(String message, String sourceId, String targetId) {
    if (message.trim().isEmpty) return;

    final currentTime = DateTime.now().toString().substring(11, 16);
    
    MessageModel messageModel = MessageModel(
      sourceId: sourceId,
      targetId: targetId,
      message: message,
      time: currentTime,
      type: 'source'
    );

    setState(() {
      messages.insert(0, messageModel);
    });

    socket.emit("message", {
      "message": message,
      "sourceId": sourceId,
      "targetId": targetId,
      "time": currentTime,
    });

    widget.onMessageSent?.call();
    scrollToBottom();
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          return;
        }
      },
      child: Scaffold(
        backgroundColor: Colors.blue.shade50,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade100,
          elevation: 0.0,
          leadingWidth: 250,
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: UserCard(user: widget.user),
          ),
          actions: [
            IconButton(
              onPressed: () {
                widget.onMessageSent?.call();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
          ],
        ),
        body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
            ? Center(child: Text(_error!))
            : RefreshIndicator(
                onRefresh: fetchMessages,
                child: SizedBox(
                  height: screenHeight,
                  width: screenWidth,
                  child: Column(
                    children: [
                      if (!isConnected)
                        Container(
                          color: Colors.red.shade100,
                          padding: const EdgeInsets.all(8),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.wifi_off),
                              SizedBox(width: 8),
                              Text('Reconnecting...'),
                            ],
                          ),
                        ),
                      Expanded(
                        child: ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          controller: scrollController,
                          itemCount: messages.length + 1,
                          itemBuilder: (context, index) {
                            if (index == messages.length) {
                              return Container(height: 70);
                            }
                            if (messages[index].type == "source") {
                              return OwnMessageCard(
                                message: messages[index].message,
                                time: messages[index].time,
                              );
                            } else {
                              return ReplyCard(
                                message: messages[index].message,
                                time: messages[index].time,
                              );
                            }
                          },
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: [
                            SizedBox(
                              width: screenWidth - 60,
                              child: Card(
                                margin: const EdgeInsets.only(
                                  left: 12.0,
                                  right: 4.0,
                                  bottom: 8.0
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0)
                                ),
                                child: TextFormField(
                                  controller: messageController,
                                  textAlignVertical: TextAlignVertical.center,
                                  keyboardType: TextInputType.multiline,
                                  minLines: 1,
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    hintText: 'Type a message...',
                                    contentPadding: const EdgeInsets.all(4.0),
                                    hintStyle: const TextStyle(color: Colors.grey),
                                    prefixIcon: InkWell(
                                      onTap: () {
                                        showModalBottomSheet(
                                          context: context,
                                          builder: (context) => bottomsheet()
                                        );
                                      },
                                      child: const Icon(Icons.attachment_outlined)
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 4.0),
                            IconButton(
                              onPressed: () {
                                sendMessage(
                                  messageController.text,
                                  currentUser.id,
                                  widget.user.id
                                );
                                setState(() {
                                  messageController.clear();
                                });
                              },
                              icon: const Icon(Icons.send, size: 20),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget bottomsheet() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16), topRight: Radius.circular(16))
      ),
      height: 280,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.insert_drive_file, 'Document', Colors.blue),
                  const SizedBox(width: 40),
                  iconCreation(Icons.camera, 'Camera', Colors.pink),
                  const SizedBox(width: 40),
                  iconCreation(Icons.insert_photo, 'Gallery', Colors.purple),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset, 'Audio', Colors.orange),
                  const SizedBox(width: 40),
                  iconCreation(Icons.location_pin, 'Location', Colors.red),
                  const SizedBox(width: 40),
                  iconCreation(Icons.person, 'Contact', Colors.blue),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(IconData icon, String text, Color color) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: Icon(
            icon,
            size: 28,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          text,
          style: TextStyle(color: Colors.black54, fontSize: 14.0),
        )
      ],
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _reconnectionTimer?.cancel();
    messageController.dispose();
    socket.disconnect();
    socket.dispose();
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }

  String formatMessageTime(dynamic timestamp) {
    try {
      // Handle if timestamp is already a formatted time string (HH:mm)
      if (timestamp is String && timestamp.length == 5 && timestamp.contains(':')) {
        return timestamp;
      }

      // Handle ISO 8601 string format
      if (timestamp is String) {
        final dateTime = DateTime.parse(timestamp);
        return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      }

      // Handle Unix timestamp (milliseconds since epoch)
      if (timestamp is int) {
        final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
        return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      }

      // If timestamp is null or invalid, return current time
      final now = DateTime.now();
      return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      // In case of any parsing errors, return current time
      final now = DateTime.now();
      return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    }
  }
}