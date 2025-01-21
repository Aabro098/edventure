import 'package:edventure/Screens/Auth%20Screens/Forgot%20Password/otp_screen.dart';
import 'package:edventure/Services/password_services.dart';
import 'package:edventure/Widgets/app_form.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:edventure/utils/snackbar.dart';
import 'package:flutter/material.dart';

class EnterDetails extends StatefulWidget {
  const EnterDetails({super.key});

  @override
  State<EnterDetails> createState() => _EnterDetailsState();
}

class _EnterDetailsState extends State<EnterDetails> {
  final TextEditingController emailController = TextEditingController();
  final emailKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final PasswordResetService resetService = PasswordResetService();

  Future<void> _handlePasswordReset() async {
    setState(() {
      _isLoading = true;
    });

    if (emailKey.currentState!.validate()) {
      try {
        final response =
            await resetService.sendResetCode(emailController.text.trim());

        if (response['success']) {
          Navigator.push(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(
                  builder: (context) => OtpScreen(
                        email: emailController.text.trim(),
                      )));
          emailController.clear();
        } else {
          // ignore: use_build_context_synchronously
          showSnackBar(context, response['message']);
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FirstAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: emailKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reset Password',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Text(
                  'Enter the email associated with your account\nand we will send an email with code\nto reset your password',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.black54),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                AppForm(
                  controller: emailController,
                  hintText: 'Email',
                ),
                const SizedBox(
                  height: 10.0,
                ),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : AppElevatedButton(
                        text: 'Next',
                        onTap: _handlePasswordReset,
                        color: Colors.blue.shade400)
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}

class FirstAppBar extends StatelessWidget implements PreferredSizeWidget {
  const FirstAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      leadingWidth: 250,
      leading: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            const SizedBox(
              width: 4.0,
            ),
            Text(
              'Back',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
