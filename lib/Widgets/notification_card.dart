import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Services/api_services.dart';
import 'package:edventure/Services/notification_api.dart';
import 'package:edventure/Widgets/user_card.dart';
import 'package:edventure/constants/Colors/colors.dart';
import 'package:edventure/models/notification.dart';
import 'package:edventure/utils/text_button.dart';
import 'package:flutter/material.dart';
import 'package:edventure/models/user.dart';
import 'package:provider/provider.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel? notification;
  const NotificationCard({
    super.key,
    this.notification,
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {
  late Future<User> _userFuture;

  void sendNotification(
    String userId,
    String senderId,
    String message,
  ) async {
    final NotificationServices notificationServices = NotificationServices();
    
    await notificationServices.addNotification(
      userId: userId,
      senderId: senderId,
      message: message,
      responseStatus: true,
      notificationStatus: true,
    );
    await notificationServices.updateNotificationStatus(widget.notification!.id, true);
    
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    if (widget.notification != null) {
      _userFuture = ApiService().fetchUserData(widget.notification!.senderId);
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays >= 1) {
      return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inMinutes >= 1) {
      return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    return FutureBuilder<User>(
      future: _userFuture,
      builder: (context, snapshot) {
        String userName = widget.notification?.senderId ?? '';

        if (snapshot.connectionState == ConnectionState.waiting) {
          userName = 'Loading...';
        } else if (snapshot.hasError) {
          userName = 'Error';
        } else if (snapshot.hasData) {
          userName = snapshot.data?.name ?? 'Unknown';
        }
        return Container(
          decoration: BoxDecoration(
            color: TAppColor.getRandomColor(),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 7.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: UserCard(isNotification: true),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                          const WidgetSpan(
                            child: SizedBox(width: 5.0),
                          ),
                          TextSpan(
                            text: widget.notification?.message ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.visible,
                    ),
                    const SizedBox(height: 5.0),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                      child: widget.notification!.responseStatus
                        ?  const SizedBox.shrink() 
                        :  widget.notification!.notificationStatus
                          ? const Text(
                              'Responded',
                              style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            )
                          : Row(
                              children: [
                                TTextButton(
                                  iconData: Icons.check,
                                  onPressed: () {
                                    sendNotification(
                                      widget.notification!.senderId,
                                      currentUser.id,
                                      'has accepted to take the classes.',
                                    );
                                  },
                                  labelText: 'YES',
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 60),
                                TTextButton(
                                  iconData: Icons.close,
                                  onPressed: () {
                                    sendNotification(
                                      widget.notification!.senderId,
                                      currentUser.id,
                                      'has rejected to take the classes.',
                                    );
                                  },
                                  labelText: 'NO',
                                  color: Colors.red,
                                ),
                              ],
                            )
                    ),
                    Text(
                      _formatDateTime(widget.notification?.dateTime ?? DateTime.now()),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
