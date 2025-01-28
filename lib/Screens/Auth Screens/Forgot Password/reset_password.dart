import 'dart:convert';
import 'package:edventure/Screens/Auth%20Screens/Forgot%20Password/enter_details.dart';
import 'package:edventure/Widgets/app_form.dart';
import 'package:edventure/constants/variable.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:edventure/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../Services/auth_services.dart';
import '../Auth/auth_screen.dart';

class ChangePassword extends StatefulWidget {
  final String email;
  const ChangePassword({super.key, required this.email});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final changePasswordKey = GlobalKey<FormState>();
  final TextEditingController changePasswordController =
      TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;
  final AuthService authService = AuthService();

  Future<void> _changePassword() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('$uri/change-password');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'newPassword': changePasswordController.text,
        }),
      );

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        showSnackBar(context, 'Password updated successfully');
        // ignore: use_build_context_synchronously
        authService.logout(context);
        Navigator.pushNamedAndRemoveUntil(
          // ignore: use_build_context_synchronously
          context,
          AuthScreen.routeName,
          (route) => false,
        );
      } else {
        final errorResponse = jsonDecode(response.body);
        // ignore: use_build_context_synchronously
        showSnackBar(context, errorResponse.toString());
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    changePasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FirstAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: changePasswordKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create new password',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                Text(
                  'Your Password must be\ndifferent from previous password.',
                  style: TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.black54),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                AppForm(
                  controller: changePasswordController,
                  hintText: 'New Password',
                  icon: Icons.visibility,
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
                  icon: Icons.visibility,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirm password is required';
                    } else if (value != changePasswordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                _isLoading == false
                    ? AppElevatedButton(
                        text: 'Change Password',
                        onTap: () {
                          if (changePasswordKey.currentState!.validate()) {
                            _changePassword();
                            setState(() {
                              changePasswordController.clear();
                              confirmPasswordController.clear();
                            });
                          }
                        },
                        color: Colors.lightGreen.shade400)
                    : Center(child: CircularProgressIndicator())
              ],
            ),
          ),
        ),
      ),
    );
  }
}
