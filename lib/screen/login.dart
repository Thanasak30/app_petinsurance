import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pet_insurance/screen/View_insurance.dart';
import 'package:pet_insurance/screen/insurance_reg1.dart';
import 'package:pet_insurance/screen/insurance_reg4.dart';
import 'package:pet_insurance/screen/login.dart';
// import '../controller/MemberController.dart';
// import '../widgets/custom_text.dart';
import '../controller/LoginController.dart';
import 'Register.dart';
// import 'Veiw_insurance.dart';
import 'package:http/http.dart' as http;

import 'officer/ListAllinsurance.dart';
import 'officer/ListAllinsurance2.dart';
import 'officer/OfficerAddinsurance.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool stateResEye = true;
  final LoginController loginController = LoginController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController userNameTextController = TextEditingController();
  TextEditingController pssswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Form(
        key: formkey,
        child: SafeArea(
          child: ListView(children: [
            buildImage(size),
            buildappname(),
            buildUser(size),
            buildPassword(size),
            buildbuttom(size),
            buildregister(context),
          ]),
        ),
      ),
    );
  }

  Row buildregister(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("ยังไม่มีบัญชี ?"),
        TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                return RegisterScreen();
              }));
            },
            child: Text("สมัครเข้าใช้งาน"))
      ],
    );
  }

  Row buildbuttom(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            width: size * 0.6,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                onPressed: () async {
                  if (formkey.currentState!.validate()) {
                    http.Response response = await loginController.userLogin(
                        userNameTextController.text, pssswordController.text);

                    if (response.statusCode == 403) {
                      print("user not found naja");
                    } else if (response.statusCode == 500) {
                      print("Error naja");
                    } else {
                      var jsonResponse = jsonDecode(response.body);
                      String usertype = jsonResponse["usertype"];
                      if (usertype == "M") {
                        print("sescces");
                        await SessionManager().set(
                            "username", jsonResponse["username"].toString());
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return Viewinsurance();
                        }));
                      } else if (usertype == "F") {
                        print("sescces");
                        await SessionManager().set(
                            "username", jsonResponse["username"].toString());
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return ListAllinsurance2();
                        }));
                      }
                    }
                  }
                },
                child: Text("เข้าสู่ระบบ"))),
      ],
    );
  }

  Padding buildappname() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
          child: Text(
        "Petinsurance",
        style: TextStyle(fontSize: 20),
      )),
    );
  }

  Padding buildImage(double size) {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: size * 0.5, child: Image.asset('Image/login.png'))
        ],
      ),
    );
  }

  Row buildUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: userNameTextController,
            decoration: InputDecoration(
              labelText: "Username",
              prefixIcon: Icon(Icons.account_circle_outlined),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            validator: (value) {
              //ถ้าใส่ email ถูก
              bool usernameValid =
                 RegExp(r'^(?=.*[A-Z])(?=.*[a-z])[A-Za-z0-9]{4,16}$')
                      .hasMatch(value!);

              //กรณีไม่ใส่ username
              if (value.isEmpty) {
                return "กรุณากรอก ตัวอักษรภาษาอังกฤษ\n [A-Z,a-z,[0-9] 4-16 ตัวอักษร";
              }
              //กรณีใส่ usename ผิด
              else if (!usernameValid) {
                return "ชื่อผู้ใช้ไม่ถูกต้อง";
              }
            },
          ),
        ),
      ],
    );
  }

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: pssswordController,
            obscureText: stateResEye,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      stateResEye = !stateResEye;
                    });
                  },
                  icon: stateResEye
                      ? Icon(
                          Icons.remove_red_eye,
                          color: Colors.black,
                        )
                      : Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.black,
                        )),
              labelText: "Password",
              prefixIcon: Icon(Icons.lock_outline),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            validator: (value) {
              // ตรวจสอบความถูกต้องของรหัสผ่าน
              bool isPasswordValid  = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])[A-Za-z0-9]{8,}$').hasMatch(value!);
              // bool isPasswordValid = RegExp(r'^[0-9]{4}$').hasMatch(value!);

              // กรณีไม่กรอกรหัสผ่าน
              if (value == null || value.isEmpty) {
                return "กรุณากรอกรหัสผ่าน มีอักษรภาษาอังกฤษและตัวเลข\nความยาวไม่เกิน 8 ตัวอักษร";
              }
              // กรณีรหัสผ่านไม่ถูกต้อง
              else if (!isPasswordValid) {
                return "รหัสผ่านไม่ถูกต้อง";
              }
              // กรณีรหัสผ่านถูกต้อง
              return null;
            },
          ),
        ),
      ],
    );
  }
}
