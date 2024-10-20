
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
      body: SizedBox(
        width: 550,
        child: CustomScrollView(
          slivers: [
            ConstantText(text: 'Recent Contacts',),
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
