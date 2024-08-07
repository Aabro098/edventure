
import 'package:edventure/Widgets/details.dart';
import 'package:edventure/utils/create_post.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:edventure/utils/post_container.dart';
import 'package:edventure/utils/text_button_second.dart';
import 'package:flutter/material.dart';
import 'package:edventure/constants/images.dart';
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
                    const Row(
                      children: [
                        Text(
                          'Arbin Shrestha',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8.0,),
                        Text(
                          '(aabro_098)',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(width: 5.0,),
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.blue, 
                              ),
                              Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        '"Those who do not know pain will never understand true peace." ✨👀',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5.0,),
                    const Details(icon: Icons.email, text : 'arbinstha71@gmail.com', color: Colors.blue,),
                    const SizedBox(height: 5.0,),
                    const Details(icon: Icons.phone, text : '9851018593'),
                    const SizedBox(height: 5.0,),
                    const Details(icon: Icons.location_city, text : 'New Baneshwor , Shankhamul'),
                    const SizedBox(height: 5.0,),
                    const Details(icon: Icons.school, text : 'Khwopa Emgineering College'),
                    const SizedBox(height: 5.0,),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Star(),
                            SizedBox(width: 2.0,),
                            Star(),
                            SizedBox(width: 2.0,),
                            Star(),
                            SizedBox(width: 2.0,),
                            Star(),
                            SizedBox(width: 8.0,),
                            Text('4.0', style: TextStyle(fontSize: 34.0),),
                          ],
                        ),
                        SizedBox(height: 5.0,),
                        Text('No of reviews : 189', style: TextStyle(fontSize: 16.0),),
                      ],
                    ),
                    const SizedBox(height: 5.0,),
                    AppElevatedButton(
                      text: 'Edit Details', 
                      onTap: (){}, 
                      color: Colors.cyan.shade600
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                    const SizedBox(height: 5.0,),
                    const CreatePostContainer(),
                    const SizedBox(height: 10.0,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade100,
                              blurRadius: 7.0,
                              offset: const Offset(0, 2)
                            )
                          ]
                        ),
                        child: const Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButtonSecond(label: 'Posts',icon: Icons.post_add,),
                              SizedBox(width: 20.0,),
                              TextButtonSecond(label: 'Reviews',icon: Icons.reviews),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10,),
                    const PostContainer(),
                    const SizedBox(height: 5.0,),
                    const PostContainer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}