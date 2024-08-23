import 'package:edventure/Screens/Friends/friend_screen.dart';
import 'package:edventure/Screens/Notifications/notification_screen.dart';
import 'package:edventure/Widgets/app_bar.dart';
import 'package:edventure/Widgets/tab_bar.dart';
import 'package:flutter/material.dart';
import '../Screens/Home Screen/home_screen.dart';
import '../Screens/Profile Screen/profile_screen.dart';
import '../Widgets/responsive.dart';

class NavScreen extends StatefulWidget {
  static const String routeName = 'nav-screen';
  const NavScreen({super.key});

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  final List<Widget> _screens = [
    const HomeScreen(),
    const Scaffold(), 
    const ProfileScreen(),
    const FriendScreen(),
    const NotificationScreen(),
  ];

  final List<IconData> _icons = [
    Icons.home,
    Icons.ondemand_video,
    Icons.account_circle_outlined,
    Icons.group_outlined,
    Icons.notifications,
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return DefaultTabController(
      length: _icons.length,
      child: Scaffold(
        appBar: Responsive.isDesktop(context)
            ? PreferredSize(
                preferredSize: Size(screenSize.width, 100.0),
                child: CustomAppBar(
                  icons: _icons,
                  selectedIndex: selectedIndex,
                  onTap: (index) => setState(() => selectedIndex = index),
                ),
              )
            : null,
        body: IndexedStack(
          index: selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: !Responsive.isDesktop(context)
            ? Container(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: CustomCurvedNavigationBar(
                  icons: _icons,
                  selectedIndex: selectedIndex,
                  onTap: (index) => setState(() => selectedIndex = index),
                  isBottomIndicator: true,
                ),
              )
            : const SizedBox.shrink(),
      ),
    );
  }
}
