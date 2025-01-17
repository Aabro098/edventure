import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Screens/Auth%20Screens/Auth/auth_screen.dart';
import 'package:edventure/Services/auth_services.dart';
import 'package:edventure/Navigation/nav_screen.dart';
import 'package:edventure/constants/colors.dart';
import 'package:edventure/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AppRoot());
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AuthService authService = AuthService();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();
  // Create a single future to be used by FutureBuilder
  late Future<void> _userDataFuture;

  @override
  void initState() {
    super.initState();
    // Initialize the future once
    _userDataFuture = _initializeUserData(context);
  }

  Future<void> _initializeUserData(BuildContext context) async {
    try {
      await authService.getUserData(context: context);
    } catch (e) {
      if (mounted) {
        _scaffoldKey.currentState?.showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldKey,
      title: 'EdVenture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: TAppColor.secondaryColor,
        ),
      ),
      onGenerateRoute: generateRoute,
      home: SafeArea(
        child: Scaffold(
          body: Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              return FutureBuilder(
                // Use the stored future instead of creating a new one
                future: _userDataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48),
                          const SizedBox(height: 16),
                          Text('Error: ${snapshot.error}'),
                        ],
                      ),
                    );
                  }

                  return userProvider.user.token.isNotEmpty
                      ? const NavScreen()
                      : const AuthScreen();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}