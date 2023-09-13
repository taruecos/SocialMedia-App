import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final String title;
  final bool isActive;

  const StatusIndicator({required this.title, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: TextStyle(color: Colors.white)),
        SizedBox(height: 5.0),
        Container(
          width: 24.0,
          height: 24.0,
          decoration: BoxDecoration(
            border: Border.all(
                color: isActive ? Colors.green : Colors.red, width: 2.0),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Center(
            child: isActive
                ? Icon(Icons.check, size: 18.0, color: Colors.green)
                : Icon(Icons.close, size: 18.0, color: Colors.red),
          ),
        ),
      ],
    );
  }
}
