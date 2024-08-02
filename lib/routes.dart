
import 'package:edventure/Screens/Home%20Screen/home_screen.dart';
import 'package:edventure/Widgets/nav_screen.dart';
import 'package:flutter/material.dart';

import 'Screens/Auth Screens/Sign In/sign_in.dart';
import 'Screens/Auth Screens/Sign Up/sign_up.dart';

Route<dynamic>generateRoute(RouteSettings routeSettings){
  switch(routeSettings.name){
    case SignInScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignInScreen()
      );
      case SignUpScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const SignUpScreen()
      );
      case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen()
      );
      case NavScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const NavScreen()
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const Scaffold(
          body: Center(
            child: Text('Screen does not exist ! '),
          ),
        )
      );
  }
}
