import 'package:edventure/Screens/Messenger/individual_chat.dart';
import 'package:edventure/Services/api_services.dart';
import 'package:edventure/Widgets/friend_card.dart';
import 'package:edventure/models/user.dart';
import 'package:flutter/material.dart';

class SelectContact extends StatefulWidget {
  const SelectContact({super.key});

  @override
  State<SelectContact> createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {

    final TextEditingController _searchController = TextEditingController();
  List<User> _searchResults = [];
  bool _isSearching = false;

  void _searchUsers(String query) async {
    if (query.isNotEmpty) {
      setState(() {
        _isSearching = true;
      });
      try {
        List<User> results = await ApiService().searchUsers(context, query);
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      } catch (e) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
      }
    } else {
      setState(() {
        _searchResults.clear();
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade100,
          elevation: 0.0,
          leadingWidth: 250,
          leading: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              'Select Contact',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold
              ),
            )
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon : Icon(
                Icons.arrow_back
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search users...',
                    hintStyle: TextStyle(
                      color: Colors.grey
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Colors.lightBlue,
                        width: 2.0
                      )
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Colors.blue, 
                        width: 2.0,        
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(
                        color: Colors.cyan,
                        width: 1.0,        
                      ),
                    ),
                    suffixIcon: _isSearching
                        ? Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              _searchUsers(_searchController.text);
                            },
                          ),
                  ),
                  onChanged: (query) {
                    _searchUsers(query); 
                  },
                ),
                const SizedBox(height: 16.0),
                
                Expanded(
                  child: _searchResults.isEmpty
                  ? Center(
                      child: _isSearching
                          ? CircularProgressIndicator()
                          : const Text(
                              'No results found',
                              style: TextStyle(color: Colors.grey),
                            ),
                    )
                  : ListView.builder(
                      itemCount: _searchResults.length,
                      itemBuilder: (context, index) {
                        final user = _searchResults[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: FriendCard(
                            suggested: false,
                            user: user,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IndividualChat(),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}