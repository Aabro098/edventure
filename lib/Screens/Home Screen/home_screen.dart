
import 'package:edventure/utils/create_post.dart';
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
    return const Scaffold(
      body : Flexible(
        flex: 2,
        child: SizedBox(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: CreatePostContainer(),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: PostContainer(),
                ),
              ),
              SliverToBoxAdapter(
                child: PostContainer(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
