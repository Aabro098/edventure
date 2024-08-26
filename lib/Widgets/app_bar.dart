import 'package:edventure/Widgets/friend_card.dart';
import 'package:flutter/material.dart';
import 'package:edventure/Services/api_services.dart';
import 'package:edventure/models/user.dart';
import 'package:edventure/utils/text_button.dart';
import 'package:edventure/Widgets/tab_bar.dart';
import '../Screens/Profile Screen/view_profile.dart';
import 'user_card.dart';

class CustomAppBar extends StatefulWidget {
  final List<IconData> icons;
  final int selectedIndex;
  final Function(int) onTap;

  const CustomAppBar({
    super.key,
    required this.icons,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<User> _searchResults = [];
  OverlayEntry? _overlayEntry;

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _searchResults.clear();
        _removeOverlay();
      } else {
        _showOverlay();
      }
    });
  }

  void _searchUsers(String query) async {
    if (query.isNotEmpty) {
      try {
        List<User> results = await ApiService().searchUsers(query);
        setState(() {
          _searchResults = results;
        });
        if (_isSearching) {
          _updateOverlay();
        }
      } catch (e) {
        setState(() {
          _searchResults = [];
        });
        if (_isSearching) {
          _updateOverlay();
        }
      }
    } else {
      setState(() {
        _searchResults.clear();
      });
      if (_isSearching) {
        _updateOverlay();
      }
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    final width = MediaQuery.of(context).size.width * 0.4; 
    final height = MediaQuery.of(context).size.height * 0.3; 

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: kToolbarHeight, 
        left: MediaQuery.of(context).size.width * 0.3, 
        width: width,
        child: Material(
          elevation: 4.0,
          child: Center(
            child: Container(
              height:  _searchResults.isNotEmpty ? height : 0.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: _searchResults.isNotEmpty
                  ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final user = _searchResults[index];
                          return FriendCard(
                            suggested: false,
                            user: user,
                            onTap : (){
                              _removeOverlay();
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProfileViewScreen(userId: user.id),
                                )
                                ).then((_){
                                  _removeOverlay();
                                });
                            }
                          );
                        },
                      ),
                  )
                  : const Center(
                      child: Text(
                        'No results found',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _updateOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _removeOverlay() {
    if (_overlayEntry != null) {
      print('Removing Overlay>>>');
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 70.0,
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            border: const Border(
              bottom: BorderSide(
                color: Colors.white,
                width: 2.0,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  "EdVenture",
                  style: TextStyle(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.blue,
                  ),
                ),
              ),
              const Spacer(),
              _isSearching
                  ? Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade100,
                              spreadRadius: 3,
                            )
                          ],
                        ),
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: Center(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search...',
                              border: InputBorder.none,
                              prefixIcon: const Icon(Icons.search_outlined),
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  _toggleSearch();
                                },
                              ),
                            ),
                            onChanged: _searchUsers,
                          ),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: CustomCurvedNavigationBar(
                        icons: widget.icons,
                        selectedIndex: widget.selectedIndex,
                        onTap: widget.onTap,
                      ),
                    ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!_isSearching)
                    TTextButton(
                      iconData: Icons.search,
                      labelText: 'Search',
                      onPressed: () {
                        _toggleSearch();
                      },
                      color: Colors.grey,
                    ),
                  const SizedBox(width: 12.0),
                  const UserCard(),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
