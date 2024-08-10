import 'package:edventure/Services/auth_services.dart';
import 'package:edventure/Widgets/app_form.dart';
import 'package:edventure/constants/Colors/colors.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = 'auth';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _signInFormKey = GlobalKey<FormState>();
  final _signUpFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSignUp = false;
  bool _isLoading = false; 

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  Future<void> _handleButtonPress() async {
    if (_isSignUp) {
      if (_signUpFormKey.currentState!.validate()) {
        setState(() {
          _isLoading = true; 
        });
        await authService.signUpUser(
          context: context,
          email: _emailController.text,
          name: _nameController.text,
          password: _passwordController.text,
        );
        setState(() {
          _isLoading = false; 
        });
      }
    } else {
      if (_signInFormKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        await authService.signInUser(
          context: context,
          email: _emailController.text,
          password: _passwordController.text,
        );
        setState(() {
          _isLoading = false; 
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            left: _isSignUp ? MediaQuery.of(context).size.width / 2 : 0,
            right: _isSignUp ? 0 : MediaQuery.of(context).size.width / 2,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: _isSignUp ? const Radius.circular(30) : Radius.zero,
                  bottomLeft: _isSignUp ? const Radius.circular(30) : Radius.zero,
                  topRight: !_isSignUp ? const Radius.circular(30) : Radius.zero,
                  bottomRight: !_isSignUp ? const Radius.circular(30) : Radius.zero,
                ),
                color: TAppColor.backgroundColor,
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "EdVenture",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 34,
                    ),
                  ),
                  SizedBox(height: 18),
                  Text(
                    "Learn and share technically and globally",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 20,
                      fontStyle: FontStyle.italic
                    ),
                  ),
                ],
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            left: _isSignUp ? 0 : MediaQuery.of(context).size.width / 2,
            right: _isSignUp ? MediaQuery.of(context).size.width / 2 : 0,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height,
              alignment: Alignment.center,
              child: SizedBox(
                width: 350,
                child: Form(
                  key: _isSignUp ? _signUpFormKey : _signInFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "EdVenture",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                            color: TAppColor.secondaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      if (_isSignUp)
                        AppForm(
                          controller: _nameController,
                          hintText: "User Name",
                        ),
                      if (_isSignUp) const SizedBox(height: 10),
                      AppForm(
                        controller: _emailController,
                        hintText: "Email",
                      ),
                      const SizedBox(height: 10),
                      AppForm(
                        controller: _passwordController,
                        hintText: "Password",
                        icon: Icons.visibility,
                      ),
                      if (!_isSignUp) const SizedBox(height: 10.0),
                      if (!_isSignUp)
                        GestureDetector(
                          onTap: () {},
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Forgot Password?",
                              style: TextStyle(
                                fontSize: 12,
                                color: TAppColor.backgroundColor,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 15),
                      AppElevatedButton(
                        text: _isSignUp ? "Sign Up" : "Login",
                        onTap: _handleButtonPress,
                        color: TAppColor.backgroundColor,
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        _isSignUp
                            ? "Already have an account?"
                            : "Don't have an account?",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5.0),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isSignUp = !_isSignUp;
                          });
                        },
                        child: Text(
                          _isSignUp ? "Login" : "Sign Up",
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading) 
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
