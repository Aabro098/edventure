import 'package:edventure/Screens/Auth%20Screens/Sign%20In/sign_in.dart';
import 'package:edventure/constants/Colors/colors.dart';
import 'package:edventure/routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EdVenture',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: TAppColor.secondaryColor
        )
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: const SignInScreen(),
    );
  }
}