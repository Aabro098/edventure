import 'package:flutter/material.dart';

class CustomTabBar extends StatelessWidget {
  final List<IconData> icons;
  final int selectedIndex;
  final Function(int) onTap;
  final bool isBottomIndicator;

  const CustomTabBar({
    super.key,
    required this.icons,
    required this.selectedIndex,
    required this.onTap,
    this.isBottomIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TabBar(
        indicatorPadding: EdgeInsets.zero,
        indicator: isBottomIndicator
            ? BoxDecoration(
                color: Colors.transparent, 
                border: Border(
                  bottom: BorderSide(
                    color: Colors.cyan.shade700,
                    width: 3.0,
                  ),
                ),
              )
            : BoxDecoration(
                color: Colors.transparent,
                border: Border(
                  top: BorderSide(
                    color: Colors.cyan.shade700,
                    width: 3.0,
                  ),
                ),
              ),
        tabs: icons
            .asMap()
            .map(
              (i, e) => MapEntry(
                i,
                Tab(
                  icon: Icon(
                    e,
                    color: i == selectedIndex ? Colors.cyan.shade600 : Colors.black45,
                    size: i == selectedIndex ? 42.0 : 30.0,
                  ),
                ),
              ),
            )
            .values
            .toList(),
        onTap: onTap,
        unselectedLabelColor: Colors.transparent,
        indicatorColor: Colors.transparent,
      ),
    );
  }
}
