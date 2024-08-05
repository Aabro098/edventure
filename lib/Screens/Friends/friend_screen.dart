
import 'package:edventure/Widgets/friend_card.dart';
import 'package:edventure/utils/contact_list.dart';
import 'package:edventure/utils/more_options.dart';
import 'package:flutter/material.dart';

class FriendScreen extends StatefulWidget {
  const FriendScreen({
    super.key,
  });

  @override
  State<FriendScreen> createState() => _FriendScreenState();
}

class _FriendScreenState extends State<FriendScreen> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(0,16,0,0),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: MoreOptionList(),
              ),
            )
          ),
          Spacer(),
          SizedBox(height: 15,),
          SizedBox(
            width: 550,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: FriendCard(),
                ),
              ],
            ),
          ),
          Spacer(),
          Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: ContactList(),
              ),
            )
          ),
        ],
      ),
    );
  }
}
