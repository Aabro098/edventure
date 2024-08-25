
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
                ConstantText(text: 'Saved Contacts',),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    // child: FriendCard(suggested: false, user: ,),
                  ),
                ),
                ConstantText(text: 'Suggested Contacts'),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    // child: FriendCard(suggested: true,),
                  ),
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

class ConstantText extends StatelessWidget {
  final String text;
  const ConstantText({
    super.key, 
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(text,               
          style: const TextStyle(
            fontSize: 18,
            color: Colors.grey,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }
}
