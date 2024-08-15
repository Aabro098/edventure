import 'package:flutter/material.dart';
import 'package:edventure/utils/text_button.dart';
import 'package:edventure/Widgets/tab_bar.dart';
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

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 70.0,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 2.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "EdVenture",
              style: TextStyle(
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: Colors.cyan.shade600,
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
                ]
              ),
              width: MediaQuery.of(context).size.width*0.4,
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
                  ),
                ),
              ),
          )
          : SizedBox(
              height: double.infinity,
              width: MediaQuery.of(context).size.width * 0.4,
              child: CustomTabBar(
                icons: widget.icons,
                selectedIndex: widget.selectedIndex,
                onTap: widget.onTap,
                isBottomIndicator: true,
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
    );
  }
}
