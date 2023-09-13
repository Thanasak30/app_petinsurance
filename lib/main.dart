import 'package:flutter/material.dart';
import 'package:pet_insurance/screen/AddPet.dart';
import 'package:pet_insurance/screen/EditProfile.dart';
import 'package:pet_insurance/screen/OfficerAddinsurance.dart';
import 'package:pet_insurance/screen/Register.dart';
import 'package:pet_insurance/screen/View_insurance.dart';
import 'package:pet_insurance/screen/insurance_reg1.dart';
import 'package:pet_insurance/screen/insurance_reg2.dart';
import 'package:pet_insurance/screen/insurance_reg3.dart';
import 'package:pet_insurance/screen/insurance_reg4.dart';
import 'package:pet_insurance/screen/login.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen()
      
    );
  }
}
