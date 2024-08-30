import 'package:edventure/models/notification.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Services/notification_api.dart';
import 'package:edventure/Widgets/notification_card.dart';
import 'package:edventure/utils/contact_list.dart';
import 'package:edventure/utils/more_options.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<NotificationModel>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _fetchNotifications();
  }

  Future<List<NotificationModel>> _fetchNotifications() async {
    final userId = Provider.of<UserProvider>(context, listen: false).user.id;
    final apiService = NotificationServices(); 
    return apiService.fetchNotifications(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: MoreOptionList(),
              ),
            ),
          ),
          const SizedBox(width: 20),
          Flexible(
            flex: 3,
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                FutureBuilder<List<NotificationModel>>(
                  future: _notificationsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return SliverToBoxAdapter(
                        child: Center(
                          child: Text('Error: ${snapshot.error}'),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const SliverToBoxAdapter(
                        child: Center(
                          child: Text('No notifications'),
                        ),
                      );
                    }

                    final notifications = snapshot.data!;
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final notification = notifications[index];
                          return NotificationCard(notification:notification);
                        },
                        childCount: notifications.length,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          const Flexible(
            flex: 2,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.all(12.0),
                child: ContactList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
