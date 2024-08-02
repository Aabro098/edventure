import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;
  final Color? iconColor;
  const Details({
    super.key,
    required this.icon,
    required this.text,
    this.color, 
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon , size: 20 , color: iconColor),
        const SizedBox(width: 8.0),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.normal,
            color: color
          ),
        ),
      ],
    );
  }
}
