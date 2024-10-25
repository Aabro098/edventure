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

  const IndividualChat({super.key, required this.user});

  @override
  IndividualChatState createState() => IndividualChatState();
}

class IndividualChatState extends State<IndividualChat> {
late io.Socket socket;
  bool show = false;
  FocusNode focusNode = FocusNode();
  final TextEditingController messageController = TextEditingController();
  List<MessageModel> messages = [];
  ScrollController scrollController = ScrollController();
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    currentUserId = Provider.of<UserProvider>(context, listen: false).user.id;
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          show = false;
        });
      }
    });
    connect();
    fetchMessages();
  }

  Future<void> fetchMessages() async {
    String url = '$uri/messages/$currentUserId/${widget.user.id}';
    
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List<dynamic> jsonMessages = json.decode(response.body);
        List<MessageModel> fetchedMessages = jsonMessages.map((json) {
          json['currentUserId'] = currentUserId;
          return MessageModel.fromJson(json);
        }).toList();

        setState(() {
          messages = fetchedMessages;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          scrollToBottom();
        });
      }
    } catch (error) {
      print('Error fetching messages: $error');
    }
  }

  void connect() {
    socket = io.io(
      uri,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );
    socket.connect();
    socket.emit("/test", currentUserId);

    socket.on("message", (msg) {
      MessageModel messageModel = MessageModel(
        type: "destination",
        message: msg["message"],
        sourceId: msg["sourceId"],
        targetId: msg["targetId"],
        time: DateTime.now().toString().substring(11, 16),
      );
      
      setState(() {
        messages.add(messageModel);
      });
      scrollToBottom();
    });
  }

  void sendMessage(String message, String sourceId, String targetId) {
    if (message.trim().isEmpty) return;

    MessageModel messageModel = MessageModel(
      type: "source",
      message: message,
      sourceId: sourceId,
      targetId: targetId,
      time: DateTime.now().toString().substring(11, 16),
    );

    setState(() {
      messages.add(messageModel);
    });

    socket.emit("message", {
      "message": message,
      "sourceId": sourceId,
      "targetId": targetId,
    });

    scrollToBottom();
  }

  void scrollToBottom() {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
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
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ],
      ),
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                controller: scrollController,
                itemCount: messages.length + 1,
                itemBuilder: (context, index) {
                  if (index == messages.length) {
                    return Container(
                      height: 70,
                    );
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
                      margin: EdgeInsets.only(
                          left: 12.0, right: 4.0, bottom: 8.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      child: TextFormField(
                        controller: messageController,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          contentPadding: EdgeInsets.all(4.0),
                          hintStyle: TextStyle(color: Colors.grey),
                          prefixIcon: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) => bottomsheet());
                              },
                              child: Icon(Icons.attachment_outlined)),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 4.0,
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage(messageController.text, currentUser.id,
                          widget.user.id);
                      setState(() {
                        messageController.clear();
                      });
                    },
                    icon: Icon(
                      Icons.send,
                      size: 20,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomsheet() {
    return Container(
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16), topRight: Radius.circular(16))),
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
    messageController.dispose();
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
}
