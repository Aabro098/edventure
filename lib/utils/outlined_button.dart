
import 'package:flutter/material.dart';

class AppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  const AppOutlinedButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.transparent,
        minimumSize: const Size(double.infinity,24),
      ), 
      child: Text(text , 
        style: TextStyle(
          color: color, 
          fontWeight: FontWeight.normal, 
          fontSize: 16
        )
      ),
    );
  }
}
