
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> pagename;
  final int selectedIndex;

  const CustomAppBar({
    super.key,
    required this.pagename,
    required this.selectedIndex, 

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 60.0, 
      decoration: BoxDecoration(
        color: Colors.cyan.shade50, 
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 2.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            pagename[selectedIndex],
            style: const TextStyle(
              letterSpacing: 0.9,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0); 
}
