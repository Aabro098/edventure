
import 'package:edventure/Providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> 
with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        toolbarHeight: 3,
        bottom: 
        user.isVerified ? 
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Unverified'),
            Tab(text: 'Verified')
          ]
        )
        : PreferredSize(preferredSize: Size(double.infinity, 20),
            child: Text(
            'Verified Users Near You'
          )
        ),
      ),
      body: user.isVerified
        ? Text('User Needs to verify')
        : TabBarView(
            controller: _tabController,
            children: [
              _unverified(),
              _verified(),
            ]
          )
    );
  }

  Widget _unverified(){
    return Scaffold();
  }

  Widget _verified(){
    return Scaffold();
  }
}
