
import 'package:edventure/Screens/Search%20Screen/search_screen.dart';
import 'package:edventure/utils/options.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/Auth Screens/Sign In/auth_screen.dart';

class MoreOptionList extends StatefulWidget {
  final List<List> moreOptionList = const [
    [Icons.search , Colors.purple, 'Search', SearchScreen()],
    [Icons.message , Colors.blue, 'Messenger'],
    [Icons.school , Colors.black, 'Institution'],
    [Icons.edit , Colors.black, 'Change Password'],
    [Icons.settings_outlined,Colors.grey, 'Settings'],
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
      // ignore: use_build_context_synchronously
      context,
      AuthScreen.routeName,
      (route) => false,
    );
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280.0),
        child: ListView.builder(
          itemCount: widget.moreOptionList.length,
          itemBuilder: (BuildContext context , int index){
            final List option = widget.moreOptionList[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Options(
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
              ),
            );
        }),
      ),
    );
  }
}