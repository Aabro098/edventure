import 'package:edventure/constants/Colors/colors.dart';
import 'package:flutter/material.dart';

class AppForm extends StatefulWidget {
  // final TextEditingController controller;
  final String hintText;
  final IconData? icon;

  const AppForm({
    super.key,
    // required this.controller,
    required this.hintText,
    this.icon,
  });

  @override
  State<AppForm> createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // controller: widget.controller,
      obscureText: widget.icon != null ? _obscureText : false,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.icon != null ? IconButton(
          icon: Icon(
            _obscureText ? widget.icon : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: TAppColor.backgroundColor
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: const BorderSide(
            color: TAppColor.secondaryColor
          ),
        ),
      ),
      validator: (value){
        return 'Error missing value';
      },
    );
  }
}
