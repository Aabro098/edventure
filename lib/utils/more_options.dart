import 'package:edventure/Widgets/user_card.dart';
import 'package:edventure/utils/options.dart';
import 'package:flutter/material.dart';

class MoreOptionList extends StatefulWidget {
  final List<List> moreOptionList = const [
    [Icons.group_add_outlined , Colors.cyan, 'Freinds'],
    [Icons.messenger_outline , Colors.blue, 'Messenger'],
    [Icons.flag , Colors.orange, 'Pages'],
    [Icons.store , Colors.blue, 'Marketplace'],
    [Icons.video_call_outlined , Colors.blue, 'Watch'],
    [Icons.calendar_month_outlined , Colors.red, 'Events'],
  ];

  const MoreOptionList({
    super.key,
  });

  @override
  State<MoreOptionList> createState() => _MoreOptionListState();
}

class _MoreOptionListState extends State<MoreOptionList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 280.0),
      child: ListView.builder(
        itemCount: 1 + widget.moreOptionList.length,
        itemBuilder: (BuildContext context , int index){
          if(index == 0){
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: UserCard(),
            );
          }
          final List option = widget.moreOptionList[index-1];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Options(
              icon : option[0],
              color : option[1],
              label : option[2]
            ),
          );
      }),
    );
  }
}