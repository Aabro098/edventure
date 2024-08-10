import 'package:edventure/Screens/Auth%20Screens/Sign%20Up/sign_up.dart';
import 'package:edventure/Services/auth_services.dart';
import 'package:edventure/Widgets/app_form.dart';
import 'package:edventure/constants/Colors/colors.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:flutter/material.dart';

class SignInScreen extends StatefulWidget {
  static const String routeName = 'sign-in';
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
    final _signInFormKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController  _passwordController = TextEditingController();

  @override
  void dispose(){
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

    void signInUser(){
    authService.signInUser(
      context: context, 
      email: _emailController.text, 
      password: _passwordController.text
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20) , 
                  bottomRight: Radius.circular(20)
                ),
                color: TAppColor.backgroundColor
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
                    "Learn and share technically",
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Center(
              child: SizedBox(
                width: 350,
                child: Form(
                  key : _signInFormKey,
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
                            color: TAppColor.secondaryColor
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      AppForm(
                        controller: _emailController,
                        hintText: "Email"
                      ),
                      const SizedBox(height: 10),
                      AppForm(
                        controller : _passwordController,
                        hintText: "Password" , 
                        icon: Icons.visibility
                      ),
                      const SizedBox(height: 10.0,),
                      GestureDetector(
                        onTap: (){},
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text("Forgot Password?" , 
                            style: TextStyle(
                              fontSize: 12,
                              color: TAppColor.backgroundColor,
                              fontWeight: FontWeight.w700
                            )
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      AppElevatedButton(
                        text: "Login",
                        onTap: () {
                          if(_signInFormKey.currentState!.validate()){
                            signInUser();
                          }
                        },
                        color: TAppColor.backgroundColor,
                      ),
                      const SizedBox(height: 20.0,),
                      const Text("Don't have an account?" , 
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500
                        )
                      ),
                      const SizedBox(height: 5.0,),
                      GestureDetector(
                        onTap : (){
                          Navigator.pushReplacementNamed(context, SignUpScreen.routeName);
                        },
                        child: const Text("Sign Up" , 
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.blue,
                            fontWeight: FontWeight.w700
                          )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
