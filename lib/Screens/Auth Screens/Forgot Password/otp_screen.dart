import 'package:edventure/Screens/Auth%20Screens/Forgot%20Password/enter_details.dart';
import 'package:edventure/Screens/Auth%20Screens/Forgot%20Password/reset_password.dart';
import 'package:edventure/Services/password_services.dart';
import 'package:edventure/utils/elevated_button.dart';
import 'package:edventure/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

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
  final PasswordResetService otpVerify = PasswordResetService();
  bool _isLoading = false;

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

  Future<void> handleOnPress() async {
    setState(() {
      _isLoading = true;
    });

    if (otpFormKey.currentState!.validate()) {
      try {
        final response = await otpVerify.verifyCode(
            widget.email, pinputController.text.trim());

        if (response['success']) {
          Navigator.pushReplacement(
              // ignore: use_build_context_synchronously
              context,
              MaterialPageRoute(builder: (context) => ChangePassword()));
          pinputController.clear();
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
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FirstAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verification',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Text(
              'Enter the code sent to your email',
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16.0,
                  color: Colors.black54),
            ),
            const SizedBox(
              height: 12.0,
            ),
            Form(
              key: otpFormKey,
              child: Column(
                children: [
                  Pinput(
                    length: 4,
                    focusNode: focusNode,
                    validator: (value) {
                      return value?.length == 4
                          ? null
                          : 'Pin must be exactly 4 digits';
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
                  const SizedBox(
                    height: 10.0,
                  ),
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : AppElevatedButton(
                          text: 'Verify',
                          onTap: handleOnPress,
                          color: Colors.blue.shade400)
                ],
              ),
            )
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
