import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class InsuranceREG3 extends StatefulWidget {
  const InsuranceREG3({super.key});

  @override
  State<InsuranceREG3> createState() => _InsuranceREG3State();
}

class _InsuranceREG3State extends State<InsuranceREG3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ตรวจสอบประวัติ"),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {},
        ),
      ),
      body: ListView(
        children: [],
      ),
    );
  }
}
