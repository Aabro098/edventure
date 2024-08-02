
import 'package:flutter/material.dart';

class ContactList extends StatelessWidget {

  const ContactList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth : 280),
      child :  Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'People Near You', 
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey
                  ),
                ),
              ),
              Icon(
                Icons.search , 
                size: 24, 
                color: Colors.grey[600],
              ),
              Icon(
                Icons.more_horiz , 
                size: 24, 
                color: Colors.grey[600],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
