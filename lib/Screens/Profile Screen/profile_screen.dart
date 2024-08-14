
import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Widgets/notification_card.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:edventure/utils/text_button.dart';
import 'package:flutter/material.dart';
import 'package:edventure/constants/images.dart';
import 'package:provider/provider.dart';
import '../../Widgets/stars.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = 'home-screen';
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      body: Row(
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
                        const SizedBox(width: 8.0,),
                        Text(
                          '(${user.username})',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(width: 8.0,),
                        Center(
                          child: user.isVerified 
                          ? const Stack(
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
                          ) 
                          : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    Text(
                      user.bio,
                      style: const TextStyle(  
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 5.0,),
                    TTextButton(
                      iconData: Icons.email, 
                      onPressed: (){}, 
                      labelText 
                        : user.email.isNotEmpty 
                        ? user.email 
                        : 'Enter Email', 
                      color: Colors.blue, 
                    ),
                    const SizedBox(height: 5.0,),
                    TTextButton(
                      iconData: Icons.phone_android, 
                      onPressed: (){}, 
                      labelText 
                        : user.phone.isNotEmpty 
                        ? user.phone 
                        : 'Enter Phone', 
                    ),
                    const SizedBox(height: 5.0,),
                    TTextButton(
                      iconData: Icons.home, 
                      onPressed: (){}, 
                      labelText 
                        : user.address.isNotEmpty 
                        ? user.address 
                        : 'Enter Adress', 
                    ),
                    const SizedBox(height: 5.0,),
                    TTextButton(
                      iconData: Icons.school, 
                      onPressed: (){}, 
                      labelText 
                        : user.education.isNotEmpty 
                        ? user.education 
                        : 'Enter Education',
                    ),
                    const SizedBox(height: 5.0,),
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
                                  ? (user.rating / user.ratingNumber).toStringAsFixed(1)
                                  : '0.0',
                              style: const TextStyle(fontSize: 20.0),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5.0,),
                        Text('No of reviews : ${user.ratingNumber}', style: const TextStyle(fontSize: 16.0),),
                      ],
                    ),
                    const SizedBox(height: 5.0,),
                    AppElevatedButton(
                      text: 'Edit Details', 
                      onTap: (){}, 
                      color: Colors.blue.shade400
                    )
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
                        child: Text('About',               
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            width: double.infinity,
                            height: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.05),
                                  spreadRadius: 2,
                                  offset: const Offset(1, 1)
                                )
                              ]
                            ),
                            child: Text(
                              user.about.isNotEmpty 
                              ? user.address
                              : 'Enter your short description',
                              style : const TextStyle(
                                fontSize : 14,
                                fontWeight : FontWeight.normal,
                                fontStyle: FontStyle.normal,
                                overflow: TextOverflow.clip
                              )
                            ) 
                          ),
                          Positioned(
                            bottom: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {},
                              child: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Recent Reviews',               
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      user.review.isNotEmpty
                        ? const NotificationCard(review : true)
                        : const Center(
                          child: Text(
                            'No Reviews available',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}