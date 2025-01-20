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
      decoration: BoxDecoration(color: Colors.blue.shade200, border: null),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            pagename[selectedIndex],
            style: const TextStyle(
              letterSpacing: 1.3,
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
