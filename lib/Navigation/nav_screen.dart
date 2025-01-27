import 'package:edventure/Screens/Main%20Screen/main_screen.dart';
import 'package:edventure/Screens/Messenger/chat_screen.dart';
import 'package:edventure/Widgets/app_bar.dart';
import 'package:edventure/Widgets/more_options.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import '../Screens/Profile Screen/profile_screen.dart';
import '../Screens/Search Screen/search_screen.dart';
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
    const RecentChatScreen(),
    const ProfileScreen(),
    const MainScreen(),
    const SearchScreen(),
    const MoreOptionList(),
  ];

  final List<IconData> _icons = [
    Bootstrap.messenger,
    Bootstrap.person,
    Icons.public,
    EvaIcons.search,
    IonIcons.list_circle,
  ];

  final List<String> pagename = [
    'Chats',
    'Your Profile',
    'EdVenture',
    'Search',
    'Menu',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          pagename: pagename,
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
