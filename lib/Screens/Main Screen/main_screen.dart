import 'package:edventure/Address/teaching_address.dart';
import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Screens/Profile%20Screen/view_profile.dart';
import 'package:edventure/Services/teaching_services.dart';
import 'package:edventure/Widgets/friend_card.dart';
import 'package:edventure/models/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<User> verifiedUsers = [];

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
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        toolbarHeight: 3,
        bottom: user.isVerified
            ? TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Unverified'),
                  Tab(text: 'Verified'),
                ],
              )
            : const PreferredSize(
                preferredSize: Size(double.infinity, 20),
                child: Text('Verified Users Near You'),
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () {
                    _showOptionsDialog(context);
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: user.isVerified
                  ? TabBarView(
                      controller: _tabController,
                      children: [
                        _unverified(),
                        _verified(),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (verifiedUsers.isNotEmpty)
                            ...verifiedUsers.map((user) {
                              return FriendCard(
                                user: user,
                                onTap: () {
                                   Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileViewScreen(userId: user.id),
                                    ),
                                  );
                                },
                              );
                            }),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final teachingAddresses = userProvider.user.teachingAddress;

    Future<void> fetchVerifiedUsers(String address) async {
      try {
        final response = await TeachingService.getVerifiedUsers(userProvider.user.id, address);

        if (response['users']?.isNotEmpty ?? false) {
          setState(() {
            verifiedUsers = List<User>.from(
              response['users'].map((userData) => User.fromMap(userData)) 
            );
          });
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No verified users found with this address.')),
          );
        }
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching users: $e')),
        );
      }
    }

    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Address'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (teachingAddresses.isEmpty)
                  const Center(
                    child: Text('No addresses available.'),
                  )
                else
                  ...teachingAddresses.map((address) {
                    return ListTile(
                      title: Text(address),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          try {
                            await TeachingService.deleteTeachingAddress(
                              userProvider.user.id, 
                              address,
                            );
                            userProvider.deleteTeachingAddress(address);
                          } catch (e) {
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                        },
                      ),
                      onTap: () {
                        fetchVerifiedUsers(address);
                        Navigator.pop(context); 
                      },
                    );
                  }),
                const SizedBox(height: 10),
                FloatingActionButton.extended(
                  onPressed: () async {
                    final newAddress = await Navigator.push<String>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TeachingAddressSelection(),
                      ),
                    );

                    if (newAddress != null) {
                      try {
                        await TeachingService.addTeachingAddress(
                          userProvider.user.id,
                          newAddress,
                        );
                        userProvider.addTeachingAddress(newAddress);

                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Address added successfully!')),
                        );
                      } catch (e) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: $e')),
                        );
                      }
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  label: const Text('Add Address'),
                  icon: const Icon(Icons.add),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _unverified() {
    return const Scaffold(
      body: Center(
        child: Text('Unverified Content'),
      ),
    );
  }

  Widget _verified() {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (verifiedUsers.isNotEmpty)
          ...verifiedUsers.map((user) {
            return FriendCard(
              user: user,
              onTap: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileViewScreen(userId: user.id),
                  ),
                );
              },
            );
          }),
        ],
      )
    );
  }
}
