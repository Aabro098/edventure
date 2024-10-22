import 'package:edventure/Widgets/user_card.dart';
import 'package:flutter/material.dart';

class IndividualChat extends StatefulWidget {
  const IndividualChat({super.key});

  @override
  State<IndividualChat> createState() => _IndividualChatState();
}

class _IndividualChatState extends State<IndividualChat> {
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
          child: UserCard(),
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
}

Widget bottomsheet(){
  return Container(

  );
}