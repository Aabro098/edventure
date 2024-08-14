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
            ? UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: Colors.cyan.shade700,
                  width: 3.0,
                ),
                insets: const EdgeInsets.symmetric(horizontal: 0),  // Adjust to make the border span the full width
              )
            : UnderlineTabIndicator(
                borderSide: BorderSide(
                  color: Colors.cyan.shade700,
                  width: 3.0,
                ),
                insets: const EdgeInsets.symmetric(horizontal: 0),  // Adjust to make the border span the full width
              ),
        tabs: icons
            .asMap()
            .map(
              (i, e) => MapEntry(
                i,
                Tab(
                  icon: Transform.translate(
                    offset: i == selectedIndex ? const Offset(0, -8) : Offset.zero,
                    child: Transform.scale(
                      scale: i == selectedIndex ? 1.1 : 0.9,
                      child: Icon(
                        e,
                        color: i == selectedIndex
                            ? Colors.cyan.shade600
                            : Colors.black45,
                        size: i == icons.length - 3 ? 36.0 : 30.0,
                      ),
                    ),
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
