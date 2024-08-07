
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
    return const Scaffold(
      body: Row(
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
          SizedBox(
            width: 550,
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('Contacts',               
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: FriendCard(),
                ),
                SliverToBoxAdapter(
                  child : SizedBox(
                    height: 20.0,
                  )
                ),
                SliverToBoxAdapter(
                  child : SizedBox(
                    height: 20.0,
                  )
                ),
                SliverToBoxAdapter(
                  child: Text('People You May Know',               
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child : SizedBox(
                    height: 20.0,
                  )
                ),
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
