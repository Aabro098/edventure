import 'dart:math';

import 'package:flutter/material.dart';

class TAppColor {
  static Color secondaryColor = Colors.blue.shade400;
  static Color backgroundColor = Colors.lightBlue.shade600;
  static final List<Color> colors = [
    Colors.lightBlue.shade100,
    Colors.lightGreen.shade100,
    Colors.purpleAccent.shade100,
    Colors.orangeAccent.shade100,
    Colors.yellow.shade100,
    Colors.redAccent.shade100
  ];
  static Color getRandomColor() {
    final random = Random();
    int index = random.nextInt(colors.length);
    return colors[index];
  }
}
