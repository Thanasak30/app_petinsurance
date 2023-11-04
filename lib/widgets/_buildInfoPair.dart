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
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        label,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: "Itim"),
      ),
      Text(
        value,
        style: TextStyle(fontSize: 16, fontFamily: "Itim"),
      ),
    ],
  );
}
}
