import 'package:edventure/Address/teaching_address.dart';
import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Services/teaching_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with SingleTickerProviderStateMixin {
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
                        children: [],
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

                        // Update the user's teaching addresses
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
    return const Scaffold(
      body: Center(
        child: Text('Verified Content'),
      ),
    );
  }
}
