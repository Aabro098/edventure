// import 'package:edventure/Widgets/friend_card.dart';
// import 'package:flutter/material.dart';
// import 'package:edventure/Services/api_services.dart';
// import 'package:edventure/models/user.dart';
// import 'package:edventure/utils/text_button.dart';
// import '../Screens/Profile Screen/view_profile.dart';

// class CustomAppBar extends StatefulWidget {

//   const CustomAppBar({
//     super.key, 
//     List<String>? pagename,
//     int? selectedIndex,
//   });

//   @override
//   State<CustomAppBar> createState() => _CustomAppBarState();
// }

// class _CustomAppBarState extends State<CustomAppBar> {
//   bool _isSearching = false;
//   final TextEditingController _searchController = TextEditingController();
//   List<User> _searchResults = [];
//   OverlayEntry? _overlayEntry;

//   void _toggleSearch() {
//     setState(() {
//       _isSearching = !_isSearching;
//       if (!_isSearching) {
//         _searchController.clear();
//         _searchResults.clear();
//         _removeOverlay();
//       } else {
//         _showOverlay();
//       }
//     });
//   }

//   void _searchUsers(String query) async {
//     if (query.isNotEmpty) {
//       try {
//         List<User> results = await ApiService().searchUsers(context ,query);
//         setState(() {
//           _searchResults = results;
//         });
//         if (_isSearching) {
//           _updateOverlay();
//         }
//       } catch (e) {
//         setState(() {
//           _searchResults = [];
//         });
//         if (_isSearching) {
//           _updateOverlay();
//         }
//       }
//     } else {
//       setState(() {
//         _searchResults.clear();
//       });
//       if (_isSearching) {
//         _updateOverlay();
//       }
//     }
//   }

//   void _showOverlay() {
//     final overlay = Overlay.of(context);
//     final width = MediaQuery.of(context).size.width * 0.9; 
//     final height = MediaQuery.of(context).size.height * 0.2; 

//     _overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         top: kToolbarHeight+20, 
//         left: 20, 
//         width: width,
//         child: Material(
//           elevation: 0.0,
//           child: Center(
//             child: Container(
//               height:  _searchResults.isNotEmpty ? height : 0.0,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10.0),
//               ),
//               child: _searchResults.isNotEmpty
//                   ? Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ListView.builder(
//                         itemCount: _searchResults.length,
//                         itemBuilder: (context, index) {
//                           final user = _searchResults[index];
//                           return FriendCard(
//                             suggested: false,
//                             user: user,
//                             onTap : (){
//                               _removeOverlay();
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => ProfileViewScreen(userId: user.id),
//                                 )
//                                 ).then((_){
//                                   _removeOverlay();
//                                 });
//                             }
//                           );
//                         },
//                       ),
//                   )
//                   : const Center(
//                       child: Text(
//                         'No results found',
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     ),
//             ),
//           ),
//         ),
//       ),
//     );
//     overlay.insert(_overlayEntry!);
//   }

//   void _updateOverlay() {
//     if (_overlayEntry != null) {
//       _overlayEntry!.markNeedsBuild();
//     }
//   }

//   void _removeOverlay() {
//     if (_overlayEntry != null) {
//       _overlayEntry!.remove();
//       _overlayEntry = null;
//     }
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     _removeOverlay();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         height: 70.0,
//         decoration: BoxDecoration(
//           color: Colors.blue.shade100,
//           border: const Border(
//             bottom: BorderSide(
//               color: Colors.white,
//               width: 2.0,
//             ),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             !_isSearching
//             ?Text(
//               "EdVenture",
//               style: TextStyle(
//                 letterSpacing: 1.2,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 24,
//                 color: Colors.blue,
//               ),
//             )
//             : SizedBox.shrink(),
//             const Spacer(),
//             _isSearching
//               ? Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(10.0),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.shade100,
//                           spreadRadius: 3,
//                         )
//                       ],
//                     ),
//                     width: MediaQuery.of(context).size.width * 0.8,
//                     child: Center(
//                       child: TextField(
//                         controller: _searchController,
//                         decoration: InputDecoration(
//                           hintText: 'Search...',
//                           border: InputBorder.none,
//                           prefixIcon: const Icon(Icons.search_outlined),
//                           suffixIcon: IconButton(
//                             icon: const Icon(Icons.close),
//                             onPressed: () {
//                               _toggleSearch();
//                             },
//                           ),
//                         ),
//                         onChanged: _searchUsers,
//                       ),
//                     ),
//                   ),
//                 )
//               : SizedBox.shrink(),
//             if (!_isSearching)
//               TTextButton(
//                 iconData: Icons.search,
//                 labelText: 'Search',
//                 onPressed: () {
//                   _toggleSearch();
//                 },
//                 color: Colors.grey,
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<String> pagename;
  final int selectedIndex;

  const CustomAppBar({
    super.key,
    required this.pagename,
    required this.selectedIndex, 

  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      height: 60.0, 
      decoration: BoxDecoration(
        color: Colors.cyan.shade50, 
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 2.0,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            pagename[selectedIndex],
            style: const TextStyle(
              letterSpacing: 0.9,
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0); 
}
