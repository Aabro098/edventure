
import 'package:edventure/Navigation/nav_screen.dart';
import 'package:flutter/material.dart';
import 'Screens/Auth Screens/Sign In/auth_screen.dart';
import 'Screens/Profile Screen/profile_screen.dart';

Route<dynamic>generateRoute(RouteSettings routeSettings){
  switch(routeSettings.name){
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen()
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
