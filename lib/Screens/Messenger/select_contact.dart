import 'package:flutter/material.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({super.key});

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        elevation: 0.0,
        leadingWidth: 250,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'Select Contact',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold
            ),
          )
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
      body: ListView(),
    );
  }
}