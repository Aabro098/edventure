
import 'package:edventure/Screens/Auth%20Screens/Sign%20In/auth_screen.dart';
import 'package:edventure/Widgets/user_card.dart';
import 'package:edventure/utils/options.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MoreOptionList extends StatefulWidget {
  final List<List> moreOptionList = const [
    [Icons.group , Colors.purple, 'Contacts'],
    [Icons.message , Colors.blue, 'Messenger'],
    [Icons.school , Colors.black, 'Institution'],
    [Icons.video_call_outlined , Colors.blue, 'Watch'],
    [Icons.settings_outlined,Colors.grey, 'Settings'],
    [Icons.logout , Colors.red, 'Log Out'],
  ];

  const MoreOptionList({
    super.key,
  });

  @override
  State<MoreOptionList> createState() => _MoreOptionListState();
}

class _MoreOptionListState extends State<MoreOptionList> {
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    Navigator.pushNamedAndRemoveUntil(
      context,
      AuthScreen.routeName,
      (route) => false,
    );
}

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280.0),
      child: ListView.builder(
        itemCount: 1 + widget.moreOptionList.length,
        itemBuilder: (BuildContext context , int index){
          if(index == 0){
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: UserCard(),
            );
          }
          final List option = widget.moreOptionList[index-1];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Options(
              onTap: (){
                if (option[2] == 'Log Out') {
                  logout();
                }
              },
              icon : option[0],
              color : option[1],
              label : option[2]
            ),
          );
      }),
    );
  }
}