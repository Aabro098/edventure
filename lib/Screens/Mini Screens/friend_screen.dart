import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Widgets/app_bar.dart';
import 'package:edventure/constants/variable.dart';
import 'package:edventure/models/user.dart';
import 'package:edventure/utils/friend_card.dart';
import 'package:edventure/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({
    super.key,
  });

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  List<dynamic> contacts = [];
  bool isLoading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<UserProvider>(context).user.id;
    fetchContacts(user);
  }

  Future<void> fetchContacts(String userId) async {
    final url = '$uri/getContacts/$userId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          contacts = (data['contacts'] as List)
              .map((contactData) => User.fromMap(contactData))
              .toList();

          isLoading = false;
        });
      } else {
        throw Exception('Failed to load contacts');
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, error.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(pagename: ['Contacts'], selectedIndex: 0),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.all(12.0),
                    sliver: SliverToBoxAdapter(
                      child: Text(
                        'Recent Contacts',
                        style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  contacts.isEmpty
                      ? SliverToBoxAdapter(
                          child: Center(
                            child: Text(
                              'No contacts found',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        )
                      : SliverPadding(
                          padding: EdgeInsets.all(12),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, index) {
                                final contact = contacts[index];
                                return FriendCard(
                                  user: contact,
                                );
                              },
                              childCount: contacts.length,
                            ),
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}
