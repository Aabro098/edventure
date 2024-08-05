import 'package:edventure/utils/contact_list.dart';
import 'package:edventure/utils/create_post.dart';
import 'package:edventure/utils/more_options.dart';
import 'package:edventure/utils/post_container.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Container(
        padding: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 0.0),
        child: const Row(
          children: [
            Flexible(
              flex: 1,
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: MoreOptionList(),
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Flexible(
              flex: 2,
              child: SizedBox(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: CreatePostContainer(),
                    ),
                    SliverToBoxAdapter(
                      child: PostContainer(),
                    ),
                    SliverToBoxAdapter(
                      child: PostContainer(),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 20.0,
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: ContactList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
