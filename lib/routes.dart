
import 'package:edventure/Navigation/nav_screen.dart';
import 'package:flutter/material.dart';

import 'Screens/Auth Screens/Sign In/sign_in.dart';
import 'Screens/Auth Screens/Sign Up/sign_up.dart';
import 'Screens/Profile Screen/profile_screen.dart';

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
      case ProfileScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ProfileScreen()
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
