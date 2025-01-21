import 'dart:math';

import 'package:flutter/material.dart';

class TAppColor {
  static Color secondaryColor = Colors.blue.shade400;
  static Color backgroundColor = Colors.lightBlue.shade600;
  static final List<Color> colors = [
    Colors.blue.shade50,
    Colors.green.shade50,
    Colors.purple.shade50,
    Colors.orange.shade50,
    Colors.yellow.shade50,
    Colors.red.shade50
  ];
  static Color getRandomColor() {
    final random = Random();
    int index = random.nextInt(colors.length);
    return colors[index];
  }
}
