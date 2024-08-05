
import 'package:edventure/Widgets/notification_card.dart';
import 'package:edventure/Widgets/user_card.dart';
import 'package:edventure/utils/contact_list.dart';
import 'package:edventure/utils/more_options.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    super.key,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body : Container(
        padding: const EdgeInsets.fromLTRB(0,16,0,0),
        child: Row(
          children: [
            const Flexible(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: MoreOptionList(),
                ),
              )
            ),
            const Spacer(),
            const SizedBox(height: 15,),
            SizedBox(
              width: 550,
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: UserCard(notification: true,),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: (){},
                            child: const NotificationCard()
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Flexible(
              flex: 2,
              child: Align(
                alignment: Alignment.centerRight,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: const ContactList(),
                ),
              )
            ),
          ],
        ),
      ),
    );
  }
}
