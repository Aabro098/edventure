import 'package:edventure/Widgets/app_bar.dart';
import 'package:edventure/constants/variable.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(pagename: ['About'], selectedIndex: 0),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView.builder(
            itemCount: about.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage(about[index]['image']!),
                ),
                title: Text(
                  about[index]['name']!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  about[index]['text']!,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
