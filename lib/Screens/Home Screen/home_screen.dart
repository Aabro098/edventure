import 'package:edventure/Widgets/details.dart';
import 'package:flutter/material.dart';
import 'package:edventure/constants/images.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Column(
        children: [
          Flexible(
            flex: 1,
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
                      SizedBox(width: 5.0,),
                      Text(
                        '(aabro_098)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
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
                  const Details(icon: Icons.star, text : '0.0' , iconColor: Colors.yellow,),
                  const SizedBox(height: 5.0,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
