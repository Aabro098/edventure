
import 'package:edventure/utils/contact_list.dart';
import 'package:edventure/utils/create_post.dart';
import 'package:edventure/utils/more_options.dart';
import 'package:edventure/utils/post_container.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return const Row(
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
                child: CreatePostContainer(),
              ),
              SliverToBoxAdapter(
                child: PostContainer()
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
    );
  }
}
