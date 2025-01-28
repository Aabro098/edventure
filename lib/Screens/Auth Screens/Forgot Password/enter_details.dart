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
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showSnackBar(context, 'Please enter an email address');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    if (emailKey.currentState!.validate()) {
      try {
        debugPrint('Sending reset code to email: $email');

        final response = await resetService.sendResetCode(email);

        if (mounted) {
          if (response['success']) {
            debugPrint('Reset code sent successfully to: $email');

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpScreen(
                  email: email,
                ),
              ),
            );
            emailController.clear();
          } else {
            debugPrint('Failed to send reset code: ${response['message']}');
            showSnackBar(context, response['message']);
          }
        }
      } catch (e) {
        debugPrint('Error during password reset: $e');
        if (mounted) {
          showSnackBar(context, 'An error occurred. Please try again.');
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
                const Text(
                  'Reset Password',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Enter the email associated with your account\nand we will send an email with code\nto reset your password',
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 20.0),
                AppForm(
                  controller: emailController,
                  hintText: 'Email',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email address';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10.0),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AppElevatedButton(
                        text: 'Next',
                        onTap: _handlePasswordReset,
                        color: Colors.blue.shade400,
                      )
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
