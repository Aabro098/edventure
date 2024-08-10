import 'package:edventure/Services/auth_services.dart';
import 'package:edventure/Widgets/app_form.dart';
import 'package:edventure/constants/Colors/colors.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:flutter/material.dart';

import '../Sign In/sign_in.dart';

class SignUpScreen extends StatefulWidget {
  static const String routeName = 'sign-up';
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _signUpFormKey= GlobalKey<FormState>();
  final AuthService authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();  

  @override
  void dispose(){
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void signUpUser(){
    authService.signUpUser(
      context: context, 
      email: _emailController.text, 
      name: _nameController.text, 
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
                  key : _signUpFormKey,
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
                        controller : _nameController,
                        hintText: "User Name" ,
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
                      const SizedBox(height: 10),
                      AppElevatedButton(
                        text: "Sign Up",
                        onTap: () {
                          if(_signUpFormKey.currentState!.validate()){
                            signUpUser();
                          }
                        },
                        color: TAppColor.backgroundColor,
                      ),
                      const SizedBox(height: 20.0,),
                      const Text("Already have an account?" , 
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500
                        )
                      ),
                      const SizedBox(height: 5.0,),
                      GestureDetector(
                        onTap : (){
                          Navigator.pushReplacementNamed(context, SignInScreen.routeName);
                        },
                        child: const Text("Login" , 
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
