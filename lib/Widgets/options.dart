import 'package:flutter/material.dart';

class Options extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final Color color;
  final String label;

  const Options({
    super.key,
    this.onTap,
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: color,
      ),
      title: Text(label),
      onTap: onTap,
    );
  }
}
