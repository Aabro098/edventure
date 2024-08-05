
import 'package:edventure/Widgets/user_card.dart';
import 'package:edventure/utils/contact_list.dart';
import 'package:edventure/utils/more_options.dart';
import 'package:flutter/material.dart';

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
    return Padding(
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
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.lightBlue.shade100,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: 80,
                      width: double.infinity,
                      child: const Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: UserCard(notification: true,),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Hello this is the Notification model.\nThis is where i have been testing the flutter application.',
                                    style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14.0,
                                    ),
                                    overflow: TextOverflow.clip,
                                  ),
                                  SizedBox(
                                    height: 5.0,
                                  ),
                                  Text('5h ago',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          const Flexible(
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
