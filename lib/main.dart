import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Screens/Auth%20Screens/Sign%20In/sign_in.dart';
import 'package:edventure/Services/auth_services.dart';
import 'package:edventure/Navigation/nav_screen.dart';
import 'package:edventure/constants/Colors/colors.dart';
import 'package:edventure/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) =>UserProvider()
    )
  ],
  child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();

  @override
  void initState(){
    super.initState();
    authService.getUserData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EdVenture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: const ColorScheme.light(
          primary: TAppColor.secondaryColor
        )
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Provider.of<UserProvider>(context).
        user.token.isNotEmpty 
          ? const NavScreen() 
          : const SignInScreen()
    );
  }
}