
import 'package:edventure/Widgets/app_bar.dart';
import 'package:flutter/material.dart';
import '../Screens/Friends/friend_screen.dart';
import '../Screens/Home Screen/home_screen.dart';
import '../Screens/Map Screen/map_screen.dart';
import '../Screens/Notifications/notification_screen.dart';
import '../Screens/Profile Screen/profile_screen.dart';
import '../Widgets/tab_bar.dart';

class NavScreen extends StatefulWidget {
  static const String routeName = '/nav_screen';
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  int selectedIndex = 2; 

  final List<Widget> _screens = [
    const NotificationScreen(),
    const ProfileScreen(),
    const MapScreen(),
    const FriendScreen(),
    const HomeScreen(),
  ];

  final List<IconData> _icons = [
    Icons.notifications,
    Icons.account_circle_outlined,
    Icons.map,
    Icons.group_outlined,
    Icons.more_vert,
  ];

  final List<String> pagename= [
    'Explore',
    'Profile',
    'Map',
    'Contacts',
    'Notifications',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          pagename : pagename,
          selectedIndex: selectedIndex,
        ),
        body: IndexedStack(
          index: selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: CustomCurvedNavigationBar(
          icons: _icons,
          selectedIndex: selectedIndex,
          onTap: (index) => setState(() => selectedIndex = index),
        ),
      ),
    );
  }
}
