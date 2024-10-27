import 'package:edventure/Widgets/app_form.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:flutter/material.dart';

class EnterDetails extends StatefulWidget {
  const EnterDetails({super.key});

  @override
  State<EnterDetails> createState() => _EnterDetailsState();
}

class _EnterDetailsState extends State<EnterDetails> {
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leadingWidth: 250,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              IconButton(
                onPressed: (){
                  Navigator.pop(context);
                }, 
                icon: Icon(
                  Icons.arrow_back
                )
              ),
              const SizedBox(
                width: 4.0,
              ),
              Text(
                'Back',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Reset Password',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 26
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(
                'Enter the email associated with your account\n and we will send an email with code\nto reset your password',
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
                controller: emailController, 
                hintText: 'Enter Email'
              ),
              const SizedBox(
                height: 10.0,
              ),
              AppElevatedButton(
                text: 'Next', 
                onTap: (){

                }, 
                color: Colors.blueAccent.shade400
              )
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose(){
    emailController.dispose();
    super.dispose();
  }
}