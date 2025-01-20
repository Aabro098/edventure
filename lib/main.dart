import 'package:edventure/Providers/user_provider.dart';
import 'package:edventure/Screens/Auth%20Screens/Auth/auth_screen.dart';
import 'package:edventure/Services/auth_services.dart';
import 'package:edventure/Navigation/nav_screen.dart';
import 'package:edventure/constants/colors.dart';
import 'package:edventure/routes.dart';
import 'package:edventure/utils/snackbar.dart';
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
  late Future<void> _userDataFuture;

  @override
  void initState() {
    super.initState();
    _userDataFuture = _initializeUserData();
  }

  Future<void> _initializeUserData() async {
    try {
      if (!mounted) return;
      await authService.getUserData(context: context);
    } catch (e) {
      if (!mounted) return;
      return Future.error(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EdVenture',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: TAppColor.secondaryColor,
        ),
      ),
      onGenerateRoute: generateRoute,
      builder: (context, child) => Material(
        child: child!,
      ),
      home: Builder(
        builder: (context) => Scaffold(
          body: Consumer<UserProvider>(
            builder: (context, userProvider, _) {
              return FutureBuilder(
                future: _userDataFuture,
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      showSnackBar(context, snapshot.error.toString());
                    });
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline,
                              size: 48, color: Colors.red),
                          const SizedBox(height: 16),
                          Text(
                            'Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _userDataFuture = _initializeUserData();
                              });
                            },
                            child: const Text('Retry'),
                          ),
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
