
import 'package:flutter/material.dart';
import 'package:edventure/Widgets/user_card.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'People Near You',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              Icon(
                Icons.search,
                size: 24,
                color: Colors.grey[600],
              ),
            ],
          ),
          const SizedBox(height: 20.0),
          const Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  UserCard(),
                  SizedBox(height: 10.0),
                  UserCard(),
                  SizedBox(height: 10.0),
                  UserCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
