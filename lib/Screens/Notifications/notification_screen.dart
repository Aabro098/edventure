import 'package:edventure/Widgets/app_bar.dart';
import 'package:edventure/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Services/notification_api.dart';
import 'package:edventure/Widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<List<NotificationModel>> _fetchNotifications(String userId) async {
    final notificationServices = NotificationServices(); 
    return notificationServices.fetchNotifications(userId);
  }

  @override
  Widget build(BuildContext context) {
    final userId = Provider.of<UserProvider>(context).user.id;
    return Scaffold(
      appBar: CustomAppBar(pagename: ['Notifications'], selectedIndex: 0),
      body: FutureBuilder<List<NotificationModel>>(
        future: userId.isNotEmpty
            ? _fetchNotifications(userId)
            : Future.error('User ID is not available'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No notifications'),
            );
          }
          final notifications = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.fromLTRB(8,8,8,4),
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final notification = notifications[index];
                      return Column(
                        children: [
                          NotificationCard(notification: notification),
                          if (index < notifications.length - 1)
                            const SizedBox(height: 8.0),
                        ],
                      );
                    },
                    childCount: notifications.length,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
