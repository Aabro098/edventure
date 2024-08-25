import 'package:edventure/Services/api_services.dart';
import 'package:flutter/material.dart';
import 'package:edventure/Widgets/notification_card.dart';
import 'package:edventure/constants/images.dart';
import 'package:edventure/models/user.dart';
import '../../Widgets/stars.dart';

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

  @override
  void initState() {
    super.initState();
    _userData = ApiService().fetchUserData(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
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
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 5.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  offset: const Offset(0, 4),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const CircleAvatar(
                              radius: 120,
                              backgroundImage: AssetImage(AppImages.profile),
                            ),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Text(
                                '(${user.username})',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              const SizedBox(width: 8.0),
                              Center(
                                child: user.isVerified
                                    ? const Row(
                                      children: [
                                        Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 8,
                                                backgroundColor: Colors.blue,
                                              ),
                                              Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 4.0),
                                          Text('Verified',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.blue
                                            ),
                                          )
                                      ],
                                    ) 
                                      : const Row(
                                        children: [
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              CircleAvatar(
                                                radius: 8,
                                                backgroundColor: Colors.grey,
                                              ),
                                              Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                              ),
                            ],
                          ),
                          user.bio.isNotEmpty
                            ? Text(
                              user.bio,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w300,
                                fontStyle: FontStyle.italic,
                              ),
                            )
                            : const SizedBox.shrink(), 
                            const SizedBox(height: 5.0),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12,0,0,0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.email,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    user.email,
                                    style:  const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),  
                            const SizedBox(height: 5.0),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12,0,0,0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.phone_android,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    user.phone,
                                    style:  const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12,0,0,0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.home,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    user.address,
                                    style:  const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5.0),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12,0,0,0),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.school,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    user.education,
                                    style:  const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),
                          const SizedBox(height: 5.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Star(
                                    count: (user.ratingNumber != 0)
                                        ? (user.rating / user.ratingNumber)
                                        : 0,
                                  ),
                                  const SizedBox(width: 5.0),
                                  Text(
                                    (user.ratingNumber != 0)
                                        ? (user.rating / user.ratingNumber)
                                            .toStringAsFixed(1)
                                        : '0.0',
                                    style: const TextStyle(fontSize: 20.0),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 5.0),
                              Text(
                                'No of reviews : ${user.ratingNumber}',
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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
                                ? const NotificationCard(review: true)
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
