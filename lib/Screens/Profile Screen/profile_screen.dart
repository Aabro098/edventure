
import 'package:edventure/Widgets/details.dart';
import 'package:edventure/Widgets/notification_card.dart';
import 'package:edventure/utils/elevated_button.dart';
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Arbin Shrestha',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
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
                        SizedBox(width: 8.0,),
                        Center(
                          child: Stack(
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
                        ),
                      ],
                    ),
                    const Text(
                      '"Those who do not know pain will never understand true peace." ✨👀',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 5.0,),
                    const Details(icon: Icons.email, text : 'arbinstha71@gmail.com', color: Colors.blue,),
                    const SizedBox(height: 5.0,),
                    const Details(icon: Icons.phone, text : '9851018593'),
                    const SizedBox(height: 5.0,),
                    const Details(icon: Icons.location_city, text : 'New Baneshwor , Shankhamul'),
                    const SizedBox(height: 5.0,),
                    const Details(icon: Icons.school, text : 'Khwopa Engineering College'),
                    const SizedBox(height: 5.0,),
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Star(count: 5,),
                            SizedBox(width: 5.0,),
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
                      color: Colors.blue.shade600
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
                        child: const Text(
                          'I am a dedicated Flutter developer with 6 months of hands-on experience. I specialize in creating efficient, cross-platform apps with a focus on intuitive design and seamless user experience. My portfolio includes projects like a Notes app and a Flappy Bird game, showcasing my passion for mobile development.',
                          style : TextStyle(
                            fontSize : 14,
                            fontWeight : FontWeight.normal,
                            fontStyle: FontStyle.normal,
                            overflow: TextOverflow.clip
                          )
                          ),
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
                      const NotificationCard(review : true),
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