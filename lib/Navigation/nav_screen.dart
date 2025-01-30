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
  final GlobalKey<SearchScreenStateful> _searchScreenKey = GlobalKey();
  int selectedIndex = 2;

  late final List<Widget> _screens;

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
  void initState() {
    super.initState();

    _screens = [
      const RecentChatScreen(),
      const ProfileScreen(),
      const MainScreen(),
      SearchScreen(key: _searchScreenKey),
      const MoreOptionList(),
    ];
  }

  void _onTabChanged(int index) {
    if (selectedIndex == 3 && index != 3) {
      _searchScreenKey.currentState?.resetState();
    }
    setState(() => selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
          onTap: _onTabChanged,
        ),
      ),
    );
  }
}
