import 'package:edventure/Screens/Auth%20Screens/Sign%20In/auth_screen.dart';
import 'package:edventure/Widgets/user_card.dart';
import 'package:edventure/utils/options.dart';
import 'package:flutter/material.dart';

class MoreOptionList extends StatefulWidget {
  final List<List> moreOptionList = const [
    [Icons.group , Colors.purple, 'Contacts'],
    [Icons.message , Colors.blue, 'Messenger'],
    [Icons.school , Colors.black, 'Institution'],
    [Icons.video_call_outlined , Colors.blue, 'Watch'],
    [Icons.calendar_month_outlined , Colors.orange, 'Events'],
    [Icons.logout , Colors.red, 'Log Out'],
  ];

  const MoreOptionList({
    super.key,
  });

  @override
  State<MoreOptionList> createState() => _MoreOptionListState();
}

class _MoreOptionListState extends State<MoreOptionList> {
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
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AuthScreen.routeName,
                    (route) => false,
                  );
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