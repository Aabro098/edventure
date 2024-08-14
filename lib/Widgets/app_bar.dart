import 'package:edventure/utils/text_button.dart';
import 'package:flutter/material.dart';
import 'package:edventure/Widgets/tab_bar.dart';

import 'user_card.dart';

class CustomAppBar extends StatelessWidget {
  final List<IconData> icons;
  final int selectedIndex;
  final Function(int) onTap;
  
  const CustomAppBar({
    super.key,
    required this.icons,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 65.0,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            offset: const Offset(0,2),
            blurRadius: 4
          )
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text("EdVenture", style: TextStyle(
              letterSpacing: 1.2,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.cyan.shade600
            ),
                    ),
          ),
          const Spacer(),
          Container(
            color: Colors.white,
            height: double.infinity,
            width: 600.0,
            child: CustomTabBar(
              icons: icons,
              selectedIndex: selectedIndex,
              onTap: onTap,
              isBottomIndicator : true
            ),
          ),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const UserCard(),
              const SizedBox(width: 12.0),
              TTextButton(
                iconData: Icons.search,
                labelText : 'Search',
                onPressed: (){},
                color: Colors.grey,
              ),
            ],
          )
        ],
      ),
    );
  }
}
