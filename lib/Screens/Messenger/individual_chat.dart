
import 'package:edventure/Widgets/user_card.dart';
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/user.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class IndividualChat extends StatefulWidget {
  final User user;
  const IndividualChat({
    super.key, 
    required this.user
  });

  @override
  State<IndividualChat> createState() => _IndividualChatState();
}

class _IndividualChatState extends State<IndividualChat> {
  late io.Socket socket;

  @override
  void initState(){
    super.initState();
    connect();
  }

  void connect(){
    socket =io.io(uri,<String , dynamic>{
      "transports" : ["websocket"],
      "autoConnect" : false 
    });
    socket.connect();
    socket.emit("/test","Hello World");
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController messageController = TextEditingController();
    double screenHeight =  MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        elevation: 0.0,
        leadingWidth: 250,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: UserCard(user : widget.user),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon : Icon(
              Icons.arrow_back
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Stack(
          children: [
            ListView(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  SizedBox(
                    width: screenWidth - 60,
                    child: Card(
                      margin: EdgeInsets.only(left: 12.0 , right: 4.0 , bottom: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0)
                      ),
                      child: TextFormField(
                        controller: messageController,
                        textAlignVertical: TextAlignVertical.center,
                        keyboardType: TextInputType.multiline,
                        maxLines: 4,
                        minLines: 1,
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
                          contentPadding: EdgeInsets.all(4.0),
                          hintStyle: TextStyle(
                            color: Colors.grey
                          ),
                          prefixIcon: InkWell(
                            onTap: (){
                              showModalBottomSheet(
                                context: context , 
                                builder: (context)=>bottomsheet()
                              );
                            },
                            child: Icon(
                              Icons.attachment_outlined
                            )
                          ),
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
                    onPressed: (){

                    }, 
                    icon: Icon(Icons.send , size: 20,)
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }  

  Widget bottomsheet(){
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16) ,  topRight: Radius.circular(16)
        )
      ),
      height: 280,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.insert_drive_file , 'Document' , Colors.blue),
                  const SizedBox(width: 40),
                  iconCreation(Icons.camera , 'Camera' , Colors.pink),
                  const SizedBox(width: 40),
                  iconCreation(Icons.insert_photo , 'Gallery' , Colors.purple),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  iconCreation(Icons.headset , 'Audio' , Colors.orange),
                  const SizedBox(width: 40),
                  iconCreation(Icons.location_pin , 'Location' , Colors.red),
                  const SizedBox(width: 40),
                  iconCreation(Icons.person , 'Contact' , Colors.blue),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget iconCreation(
    IconData icon ,
    String text,
    Color color
  ){
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
          style: TextStyle(
            color: Colors.black54,
            fontSize: 14.0
          ),
        )
      ],
    );
  }
}
