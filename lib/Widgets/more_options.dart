import 'package:edventure/Screens/Mini%20Screens/about_screen.dart';
import 'package:edventure/Screens/Auth%20Screens/Forgot%20Password/reset_password.dart';
import 'package:edventure/Screens/Mini%20Screens/feedback_screen.dart';
import 'package:edventure/Screens/Mini%20Screens/friend_screen.dart';
import 'package:edventure/Services/auth_services.dart';
import 'package:edventure/Widgets/options.dart';
import 'package:edventure/utils/text_button.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class MoreOptionList extends StatefulWidget {
  final List<List> moreOptionList = const [
    [Icons.group, Colors.grey, 'Contacts', FriendScreen()],
    [Icons.school, Colors.grey, 'Institution'],
    [Bootstrap.person, Colors.grey, 'Change Name'],
    [Icons.edit, Colors.grey, 'Change Password', ChangePassword()],
    [
      Icons.help_center_outlined,
      Colors.grey,
      'Give Feedback',
      FeedbackScreen()
    ],
    [AntDesign.group_outline, Colors.grey, 'About', AboutScreen()],
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
                itemBuilder: (BuildContext context, int index) {
                  final List option = widget.moreOptionList[index];
                  return Options(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => option[3],
                          ),
                        );
                      },
                      icon: option[0],
                      color: option[1],
                      label: option[2]);
                }),
          ),
          Center(
            child: TTextButton(
              iconData: AntDesign.close_circle_outline,
              onPressed: () {
                authService.logout(context);
              },
              labelText: 'Logout',
              color: Colors.red,
            ),
          )
        ],
      ),
    );
  }
}
