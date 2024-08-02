import 'package:flutter/material.dart';

class TextButtonSecond extends StatelessWidget {
  final String label;
  final IconData icon;
  const TextButtonSecond({
    super.key,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
    onPressed: (){},
     child: Row(
      children: [
        Text(label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),),
        const SizedBox(width: 5,),
        Icon(icon,size: 18,)
      ],
    ));
  }
}
