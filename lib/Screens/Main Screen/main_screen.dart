import 'package:edventure/Address/teaching_address.dart';
import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Services/teaching_services.dart';
import 'package:edventure/models/user_filter.dart';
import 'package:edventure/utils/friend_card.dart';
import 'package:edventure/Widgets/options_bottomsheet.dart';
import 'package:edventure/models/user.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

import '../Profile Screen/view_profile.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _skillController = TextEditingController();
  List<User> verifiedUsers = [];
  List<User> unverifiedUsers = [];
  bool _isFirstBuild = true;
  String? _currentAddress;
  final UserFilter _filter = UserFilter();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isFirstBuild) {
      _isFirstBuild = false;
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final teachingAddresses = userProvider.user.teachingAddress;

      if (teachingAddresses.isNotEmpty) {
        _currentAddress = teachingAddresses[0];
        _fetchVerifiedUsers(_currentAddress!);
        _fetchUnverifiedUsers(_currentAddress!);
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _skillController.dispose();
    super.dispose();
  }

  Future<void> _fetchVerifiedUsers(String address) async {
    if (!mounted) return;

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response =
          await TeachingService.getVerifiedUsers(userProvider.user.id, address);

      if (!mounted) return;

      setState(() {
        verifiedUsers = (response['users'] ?? [])
            .map<User>((userData) => User.fromMap(userData))
            .toList();
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          verifiedUsers = [];
        });
      }
    }
  }

  Future<void> _fetchUnverifiedUsers(String address) async {
    if (!mounted) return;

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final response = await TeachingService.getUnverifiedUsers(
          userProvider.user.id, address);

      if (!mounted) return;

      setState(() {
        unverifiedUsers = (response['users'] ?? [])
            .map<User>((userData) => User.fromMap(userData))
            .toList();
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          unverifiedUsers = [];
        });
      }
    }
  }

  Future<void> _handleAddressDelete(UserProvider userProvider, String address,
      BuildContext dialogContext) async {
    try {
      await TeachingService.deleteTeachingAddress(
        userProvider.user.id,
        address,
      );
      userProvider.deleteTeachingAddress(address);

      if (!mounted) return;

      if (_currentAddress == address) {
        final addresses = userProvider.user.teachingAddress;
        if (addresses.isNotEmpty) {
          _currentAddress = addresses[0];
          _fetchVerifiedUsers(_currentAddress!);
          _fetchUnverifiedUsers(_currentAddress!);
        } else {
          _currentAddress = null;
          setState(() {
            verifiedUsers = [];
            unverifiedUsers = [];
          });
        }
      }

      // ignore: use_build_context_synchronously
      Navigator.pop(dialogContext);
    } catch (e) {
      if (mounted) {
        // ignore: use_build_context_synchronously
        Navigator.pop(dialogContext);
      }
    }
  }

  Future<void> _handleAddNewAddress(
      UserProvider userProvider, BuildContext dialogContext) async {
    final newAddress = await Navigator.push<String>(
      dialogContext,
      MaterialPageRoute(
        builder: (context) => const TeachingAddressSelection(),
      ),
    );

    if (!mounted) return;

    if (newAddress != null) {
      try {
        await TeachingService.addTeachingAddress(
          userProvider.user.id,
          newAddress,
        );
        userProvider.addTeachingAddress(newAddress);

        if (_currentAddress == null) {
          _currentAddress = newAddress;
          _fetchVerifiedUsers(newAddress);
          _fetchUnverifiedUsers(newAddress);
        }
      } catch (e) {
        // Silent error handling
      }
    }
    if (mounted) {
      // ignore: use_build_context_synchronously
      Navigator.pop(dialogContext);
    }
  }

  void _showOptionsDialog(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final teachingAddresses = userProvider.user.teachingAddress;

    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
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
                        onPressed: () => _handleAddressDelete(
                            userProvider, address, dialogContext),
                      ),
                      onTap: () {
                        _currentAddress = address;
                        _fetchVerifiedUsers(address);
                        _fetchUnverifiedUsers(address);
                        Navigator.pop(dialogContext);
                      },
                      selected: _currentAddress == address,
                    );
                  }),
                const SizedBox(height: 10),
                FloatingActionButton.extended(
                  onPressed: () =>
                      _handleAddNewAddress(userProvider, dialogContext),
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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (unverifiedUsers.isNotEmpty)
              ...unverifiedUsers.map((user) {
                return FriendCard(
                  user: user,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileViewScreen(userId: user.id),
                      ),
                    );
                  },
                );
              }),
          ],
        ),
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            elevation: 0.0,
            toolbarHeight: 3,
            backgroundColor: Colors.blue.shade200,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            bottom: user.isVerified
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(kTextTabBarHeight),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.blue,
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.black87,
                      indicatorWeight: 2,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Unverified'),
                              SizedBox(width: 12.0),
                              Icon(
                                Icons.verified_rounded,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Verified'),
                              SizedBox(width: 12.0),
                              Icon(
                                Icons.verified_rounded,
                                color: Colors.blue,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : const PreferredSize(
                    preferredSize: Size(double.infinity, 24),
                    child: Text('Verified Users Near You'),
                  ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: SliverToBoxAdapter(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return _buildFilterOptions();
                            });
                      },
                      icon: Icon(Icons.filter_list)),
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                    onPressed: () => _showOptionsDialog(context),
                    icon: const Icon(Icons.more_horiz),
                  ),
                ],
              ),
            ),
          ),
          if (user.teachingAddress.isEmpty)
            const SliverFillRemaining(
              child: Center(
                child: Text('No address available'),
              ),
            )
          else if (user.isVerified)
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _unverified(),
                  _verified(),
                ],
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final user = verifiedUsers[index];
                  return FriendCard(
                    user: user,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileViewScreen(userId: user.id),
                        ),
                      );
                    },
                  );
                },
                childCount: verifiedUsers.length,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _applyFilters() async {
    if (!mounted) return;

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final response = await TeachingService.filterUsers(
        userId: userProvider.user.id,
        address: _currentAddress!,
        filters: _filter.toJson(),
      );

      if (!mounted) return;

      setState(() {
        verifiedUsers = (response['verifiedUsers'] ?? [])
            .map<User>((userData) => User.fromMap(userData))
            .toList();
        unverifiedUsers = (response['unverifiedUsers'] ?? [])
            .map<User>((userData) => User.fromMap(userData))
            .toList();
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to apply filters')),
        );
      }
    }
  }

  void _showGenderFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select Gender',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...['Male', 'Female', 'Others', 'Prefer not to say'].map(
              (gender) => ListTile(
                title: Text(gender),
                onTap: () {
                  setState(() {
                    _filter.gender = gender;
                  });
                  Navigator.pop(context);
                  _applyFilters();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSkillsFilter(BuildContext context) {
    final List<String> selectedSkills = _filter.skills ?? [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Container(
          padding: EdgeInsets.fromLTRB(
              16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Add Skills',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _skillController,
                      decoration: const InputDecoration(
                        hintText: 'Enter a skill...',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (value) {
                        if (value.isNotEmpty) {
                          setState(() {
                            if (!selectedSkills.contains(value.trim())) {
                              selectedSkills.add(value.trim());
                            }
                            _skillController.clear();
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      if (_skillController.text.isNotEmpty) {
                        setState(() {
                          if (!selectedSkills
                              .contains(_skillController.text.trim())) {
                            selectedSkills.add(_skillController.text.trim());
                          }
                          _skillController.clear();
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (selectedSkills.isNotEmpty)
                Flexible(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: selectedSkills
                        .map((skill) => Chip(
                              label: Text(skill),
                              deleteIcon: const Icon(Icons.close, size: 18),
                              onDeleted: () {
                                setState(() {
                                  selectedSkills.remove(skill);
                                });
                              },
                            ))
                        .toList(),
                  ),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _filter.skills = selectedSkills;
                      });
                      Navigator.pop(context);
                      _applyFilters();
                    },
                    child: const Text('Apply Filters'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOptions() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OptionsBottom(
            options: [
              {
                "text":
                    "Gender${_filter.gender != null ? ' (${_filter.gender})' : ''}",
                "icon": Bootstrap.person,
                "onTap": () => _showGenderFilter(context),
              },
              {
                "text":
                    "Skills${_filter.skills?.isNotEmpty == true ? ' (${_filter.skills!.length})' : ''}",
                "icon": Bootstrap.star,
                "onTap": () => _showSkillsFilter(context),
              },
            ],
            option: 'Filter Options',
          ),
          if (_filter.gender != null || _filter.skills?.isNotEmpty == true)
            TextButton(
              onPressed: () {
                setState(() {
                  _filter.gender = null;
                  _filter.skills = null;
                });
                _fetchVerifiedUsers(_currentAddress!);
                _fetchUnverifiedUsers(_currentAddress!);
              },
              child: const Text('Clear All Filters'),
            ),
        ],
      ),
    );
  }
}
