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
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon , size: 28 , color: color,),
          const SizedBox(
            width : 6.0,
          ),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18.0
              ),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
