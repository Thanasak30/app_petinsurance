
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pet_insurance/screen/AddPet.dart';
import 'package:pet_insurance/screen/EditPet.dart';
import 'package:pet_insurance/screen/EditProfile.dart';
import 'package:pet_insurance/screen/ListPet.dart';
import 'package:pet_insurance/screen/Register.dart';
import 'package:pet_insurance/screen/User/View_insurance2.dart';
import 'package:pet_insurance/screen/View_insurance.dart';
import 'package:pet_insurance/screen/insurance_reg1.dart';
import 'package:pet_insurance/screen/insurance_reg2.dart';
import 'package:pet_insurance/screen/insurance_reg4.dart';
import 'package:pet_insurance/screen/insurance_reg5.dart';
import 'package:pet_insurance/screen/login.dart';

import 'screen/Payments.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Viewinsurance2()
      
    );
  }
}
