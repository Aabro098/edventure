import 'package:flutter/material.dart';

class Star extends StatelessWidget {
  final int count;

  const Star({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        count,
        (index) => const Icon(
          Icons.star,
          color: Colors.yellow,
          size: 20,
        ),
      ),
    );
  }
}
