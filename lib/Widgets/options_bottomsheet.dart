import 'package:flutter/material.dart';

class OptionsBottom extends StatelessWidget {
  final List<Map<String, dynamic>> options;
  final String option;

  const OptionsBottom({
    super.key,
    required this.options,
    required this.option,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            option,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(
            color: Colors.grey[200],
          ),
          ...options.map((option) {
            return GestureDetector(
              onTap: option['onTap'],
              child: ListTile(
                leading: Icon(
                  option['icon'],
                  size: 24,
                  color: option['color'] ?? Colors.black54,
                ),
                title: Text(
                  option['text'],
                  style: TextStyle(
                    color: option['color'] ?? Colors.black54,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
