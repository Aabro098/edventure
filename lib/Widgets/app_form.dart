import 'package:edventure/constants/colors.dart';
import 'package:flutter/material.dart';

class AppForm extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? icon;
  final String? Function(String?)? validator;

  const AppForm(
      {super.key,
      required this.controller,
      required this.hintText,
      this.icon,
      this.validator});

  @override
  State<AppForm> createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.icon != null ? _obscureText : false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Colors.grey.shade200),
        suffixIcon: widget.icon != null
            ? IconButton(
                icon: Icon(
                  _obscureText ? widget.icon : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: TAppColor.backgroundColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(
            color: TAppColor.secondaryColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.blue.shade600, width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Enter ${widget.hintText}';
        }
        return null;
      },
    );
  }
}
