import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class buileinfo extends StatelessWidget {
  const buileinfo({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // ความหนาของ Card
      margin:
          EdgeInsets.symmetric(vertical: 8, horizontal: 16), // ระยะห่างของ Card
      child: Padding(
        padding: EdgeInsets.all(16), // ระยะห่างของข้อมูลภายใน Card
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    
    );
  }
}
