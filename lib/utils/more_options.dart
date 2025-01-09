
import 'package:edventure/Screens/Auth%20Screens/Forgot%20Password/reset_password.dart';
import 'package:edventure/Screens/Friends/friend_screen.dart';
import 'package:edventure/Services/auth_services.dart';
import 'package:edventure/utils/options.dart';
import 'package:flutter/material.dart';

class MoreOptionList extends StatefulWidget {
  final List<List> moreOptionList = const [
    [Icons.group , Colors.grey, 'Contacts', FriendScreen()],
    [Icons.school , Colors.grey, 'Institution'],
    [Icons.edit , Colors.grey, 'Change Password',ChangePassword()],
    [Icons.settings_outlined,Colors.grey, 'Settings'],
  ];

  const MoreOptionList({
    super.key,
  });

  @override
  State<MoreOptionList> createState() => _MoreOptionListState();
}

class _MoreOptionListState extends State<MoreOptionList> {
  final AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.moreOptionList.length,
              itemBuilder: (BuildContext context , int index){
                final List option = widget.moreOptionList[index];
                return Options(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => option[3], 
                      ),
                    );
                  },
                  icon : option[0],
                  color : option[1],
                  label : option[2]
                );
            }),
          ),
          Center(
            child: GestureDetector(
              onTap: () async {
                await authService.logout(context);
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}