import 'package:flutter/material.dart';

class OptionsBottom extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const OptionsBottom({
    super.key,
    required this.text,
    required this.icon,
    this.color = Colors.black54,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: color,
          ),
          SizedBox(
            width: 20,
          ),
          Column(
            children: [
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.w400,
                  fontSize: 20
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
