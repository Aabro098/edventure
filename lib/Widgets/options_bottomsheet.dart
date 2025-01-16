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
    this.color = Colors.grey,
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
                  fontWeight: FontWeight.bold,
                  fontSize: 24
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                text,
                style: TextStyle(
                  color: color,
                  fontSize: 16
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
