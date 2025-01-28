import 'package:edventure/Services/password_services.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

import '../../../utils/snackbar.dart';
import 'enter_details.dart';
import 'reset_password.dart';

class OtpScreen extends StatefulWidget {
  final String email;
  const OtpScreen({super.key, required this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpFormKey = GlobalKey<FormState>();
  late final FocusNode focusNode;
  final TextEditingController pinputController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;
  final PasswordResetService otpVerify = PasswordResetService();

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
      color: Colors.black,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(color: Colors.blue.shade100),
    ),
  );

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  Future<void> handleOnPress() async {
    setState(() {
      _isLoading = true;
    });

    final email = widget.email;
    final pin = pinputController.text.trim();

    if (otpFormKey.currentState!.validate()) {
      try {
        final response = await otpVerify.verifyCode(email, pin);

        if (mounted) {
          if (response['success']) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChangePassword(email: email),
              ),
            );
            pinputController.clear();
          } else {
            showSnackBar(context, response['message']);
          }
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verification',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Enter the code sent to ${widget.email}',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12.0),
            Form(
              key: otpFormKey,
              child: Column(
                children: [
                  Pinput(
                    controller: pinputController,
                    length: 4,
                    focusNode: focusNode,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'PIN is required';
                      }
                      if (value.length != 4) {
                        return 'PIN must be exactly 4 digits';
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                        return 'PIN must contain only digits';
                      }
                      return null;
                    },
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.cyan),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 16.0),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : AppElevatedButton(
                          text: 'Verify',
                          onTap: handleOnPress,
                          color: Colors.blue.shade400,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    pinputController.dispose();
    focusNode.dispose();
    super.dispose();
  }
}
