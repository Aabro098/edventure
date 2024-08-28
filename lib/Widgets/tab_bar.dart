import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomCurvedNavigationBar extends StatelessWidget {
  final List<IconData> icons;
  final int selectedIndex;
  final Function(int) onTap;
  final bool isBottomIndicator;

  const CustomCurvedNavigationBar({
    super.key,
    required this.icons,
    required this.selectedIndex,
    required this.onTap,
    this.isBottomIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (!isBottomIndicator)
          Align(
            alignment: Alignment.topCenter,
            child: _buildCurvedNavigationBar(),
          ),
        if (isBottomIndicator)
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildCurvedNavigationBar(),
          ),
      ],
    );
  }

  Widget _buildCurvedNavigationBar() {
    return CurvedNavigationBar(
      index: selectedIndex,
      height: 60.0,
      items: icons.map((icon) {
        int index = icons.indexOf(icon);
        return Transform.translate(
          offset: index == selectedIndex ? const Offset(0, 8) : Offset.zero,
          child: Transform.scale(
            scale: index == selectedIndex ? 1.1 : 0.9,
            child: Icon(
              icon,
              color: index == selectedIndex
                  ? Colors.blue
                  : Colors.black45,
              size: index == icons.length - 3 ? 30.0 : 28.0,
            ),
          ),
        );
      }).toList(),
      color: Colors.blue.shade100,
      backgroundColor: isBottomIndicator ?  Colors.white :  Colors.lightBlue.shade100,
      buttonBackgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 500),
      onTap: onTap,
    );
  }
}
