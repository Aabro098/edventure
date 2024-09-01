import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Services/api_services.dart';
import 'package:edventure/Services/notification_api.dart';
import 'package:edventure/Widgets/user_details.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:edventure/Widgets/notification_card.dart';
import 'package:edventure/constants/images.dart';
import 'package:edventure/models/user.dart';
import 'package:provider/provider.dart';

class ProfileViewScreen extends StatefulWidget {
  final String userId;
  const ProfileViewScreen({
    super.key,
    required this.userId,
  });

  @override
  State<ProfileViewScreen> createState() => _ProfileViewScreenState();
}

class _ProfileViewScreenState extends State<ProfileViewScreen> {

  late Future<User> _userData;
  void sendNotification(
    String userId,
    String senderId,
    String message
  ) async {
    final NotificationServices notificationServices = NotificationServices();
    await notificationServices.addNotification(
      userId: userId,
      senderId: senderId,
      message: message, 
      notificationStatus: false,
      responseStatus: false, 
    );
  }

  @override
  void initState() {
    super.initState();
    _userData = ApiService().fetchUserData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: FutureBuilder<User>(
        future: _userData,
        builder: (context , snapshot){
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          } else{
            final user = snapshot.data!;
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      UserDetails(user: user),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20,8,20,8),
                        child: AppElevatedButton(
                          text: 'Send Request', 
                          onTap: (){
                            sendNotification(
                              user.id,
                              currentUser.id,
                              ' wants to make a contact with you.',
                            );
                          }, 
                          color: Colors.green.shade600
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 250,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(AppImages.background),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  'About',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Stack(
                                children: [
                                  SingleChildScrollView(
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      width: double.infinity,
                                      height: 90,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.05),
                                            spreadRadius: 2,
                                            offset: const Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                      child : Text(
                                        user.about.isNotEmpty
                                            ? user.about
                                            : 'No description available', 
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                          fontStyle: FontStyle.normal,
                                          overflow: TextOverflow.clip,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Recent Reviews',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              user.review.isNotEmpty
                                ? const NotificationCard()
                                : const Center(
                                    child: Text(
                                      'No Reviews available',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },      
      ),
    );
  }
}

