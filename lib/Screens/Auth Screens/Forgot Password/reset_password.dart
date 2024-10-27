import 'package:edventure/Screens/Auth%20Screens/Forgot%20Password/enter_details.dart';
import 'package:edventure/Widgets/app_form.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:flutter/material.dart';

import '../Auth/auth_screen.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final changePasswordKey = GlobalKey<FormState>();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FirstAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: changePasswordKey,
          child: Column(
            children: [
              Text(
                'Create new password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0
                ),
                textAlign: TextAlign.left,
              ),    
              const SizedBox(
                height: 8.0,
              ),
              Text(
                'Your Password must be\ndifferent from previous password.',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: Colors.black54
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 20.0,
              ),
              AppForm(
                controller: passwordController, 
                hintText: 'Password',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  } else if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              AppForm(
                controller: confirmPasswordController, 
                hintText: 'Confirm Password',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm password is required';
                  } else if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10.0,
              ),
              AppElevatedButton(
                text: 'Change Password', 
                onTap: (){
                  if(changePasswordKey.currentState!.validate()){
                    Navigator.pushNamedAndRemoveUntil(
                      context, 
                      AuthScreen.routeName, 
                      (route) => false
                    );
                  }
                }, 
                color: Colors.blueAccent.shade400)
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose(){
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}