import 'package:flutter/material.dart';
import 'package:pet_insurance/screen/login.dart';
import 'package:pet_insurance/widgets/custom_text.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../controller/MemberController.dart';

// import '../controller/MemberController.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  var dateFormat = DateFormat('dd-MM-yyyy');
  DateTime currentDate = DateTime.now();
  DateTime? birthday;
  final MemberController memberController = MemberController();

  TextEditingController userNameTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();
  TextEditingController fullnameTextController = TextEditingController();
  TextEditingController AgeTextController = TextEditingController();
  TextEditingController GenderTextController = TextEditingController();
  TextEditingController nationalityTextController = TextEditingController();
  TextEditingController MobilenumberTextController = TextEditingController();
  TextEditingController birthdayTextController = TextEditingController();
  TextEditingController EmailTextController = TextEditingController();
  TextEditingController IdCardTextController = TextEditingController();
  TextEditingController AdddressTextController = TextEditingController();
  TextEditingController IDlineTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("สร้างบัญชี"),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return LoginScreen();
                },
              ),
            );
          },
        ),
      ),
      body: Form(
        key: formkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildappname(),
              buildusername(size),
              buildPassword(size),
              buildfullname(size),
              buildage(size),
              buildgender(size),
              buildnationality(size),
              buildIDcard(size),
              buildmobile(size),
              buildbirthday(size),
              buildemail(size),
              buildaddress(size),
              buildidline(size),
              buildbuttom(size)
            ],
          ),
        ),
      ),
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
                    http.Response response = await memberController.addMember(
                        AgeTextController.text,
                        MobilenumberTextController.text,
                        EmailTextController.text,
                        GenderTextController.text,
                        fullnameTextController.text,
                        IdCardTextController.text,
                        AdddressTextController.text,
                        birthdayTextController.text,
                        passwordTextController.text,
                        nationalityTextController.text,
                        IDlineTextController.text,
                        userNameTextController.text);
                    if (response.statusCode == 500) {
                      print("Error!");
                    } else {
                      print("Member was added successfully!");
                    }
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) {
                          return LoginScreen();
                        },
                      ),
                    );
                  }
                },
                child: Text("สร้างบัญชี"))),
      ],
    );
  }

  Row buildidline(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: IDlineTextController,
            decoration: InputDecoration(
              labelText: "ไอดีไลน์",
              prefixIcon: Icon(Icons.account_circle_outlined),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            validator: (value) {
              // กรณีไม่กรอกไอดีไลน์
              if (value!.isEmpty) {
                return "กรุณากรอกไอดีไลน์ของคุณ";
              }
            },
          ),
        ),
      ],
    );
  }

  Row buildaddress(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: AdddressTextController,
            decoration: InputDecoration(
              labelText: "ที่อยู่",
              prefixIcon: Icon(Icons.account_circle_outlined),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            validator: (value) {
              // กรณีไม่กรอกที่อยู่
              if (value!.isEmpty) {
                return "กรุณากรอกที่อยู่ของคุณ";
              }
            },
          ),
        ),
      ],
    );
  }

  Row buildemail(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: EmailTextController,
            decoration: InputDecoration(
              labelText: "อีเมลล์",
              prefixIcon: Icon(Icons.account_circle_outlined),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            validator: (value) {
              // ตรวจสอบความถูกต้องของหมายเลขโทรศัพท์
              bool isEmailValid =
                  RegExp(r"^(?=.*[A-Za-z0-9@._-])[A-Za-z0-9@._-]{5,60}$")
                      .hasMatch(value!);

              // กรณีไม่กรอกหมายเลขโทรศัพท์
              if (value.isEmpty) {
                return "กรุณากรอกอีเมลล์ของคุณ";
              }
              //กรณีหมายเลขโทรศัพท์ไม่ถูกต้อง
              else if (!isEmailValid) {
                return "กรุณากรอกอีเมลล์ของคุณให้ถูกต้อง";
              }
            },
          ),
        ),
      ],
    );
  }

  Row buildbirthday(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            onTap: () async {
              DateTime? tempDate = await showDatePicker(
                  context: context,
                  initialDate: currentDate,
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2100));
              setState(() {
                birthday = tempDate;
                birthdayTextController.text = dateFormat.format(birthday!);
              });
              print(birthday);
            },
            readOnly: true,
            controller: birthdayTextController,
            decoration: InputDecoration(
              labelText: "วัน/เดือน/ปีเกิด",
              prefixIcon: Icon(Icons.calendar_month),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return "กรุณาเลือกวันที่";
              }
            },
          ),
        ),
      ],
    );
  }

  Row buildmobile(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: MobilenumberTextController,
            decoration: InputDecoration(
              labelText: "หมายเลขโทรศัพท์",
              prefixIcon: Icon(Icons.account_circle_outlined),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            validator: (value) {
              // ตรวจสอบความถูกต้องของหมายเลขโทรศัพท์
              bool isMobileValid =
                  RegExp(r'^(06|08|09)[0-9]{8}$').hasMatch(value!);

              // กรณีไม่กรอกหมายเลขโทรศัพท์
              if (value.isEmpty) {
                return "กรุณากรอกหมายเลขโทรศัพท์ของคุณ";
              }
              //กรณีหมายเลขโทรศัพท์ไม่ถูกต้อง
              else if (!isMobileValid) {
                return "กรุณากรอกหมายเลขโทรศัพท์ของคุณให้ถูกต้อง\n (06/08/09)";
              }
            },
          ),
        ),
      ],
    );
  }

  Row buildIDcard(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: IdCardTextController,
            decoration: InputDecoration(
              labelText: "บัตรประชาชน 13 หลัก",
              prefixIcon: Icon(Icons.account_circle_outlined),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            validator: (value) {
              // ตรวจสอบความถูกต้องของบัตรประชาชน 13 หลัก
              bool isIdcardValid = RegExp(r'^[0-9]{13}$').hasMatch(value!);

              // กรณีไม่กรอกบัตรประชาชน 13 หลัก
              if (value.isEmpty) {
                return "กรุณากรอกเลขบัตรประชาชน 13 หลักของคุณ";
              }
              //กรณีบัตรประชาชน 13 หลักไม่ถูกต้อง
              else if (!isIdcardValid) {
                return "กรุณากรอกเลขบัตรประชาชน 13 หลักของคุณเป็นตัวเลขเท่านั้น";
              }
            },
          ),
        ),
      ],
    );
  }

  Row buildnationality(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: nationalityTextController,
            decoration: InputDecoration(
              labelText: "สัญชาติ",
              prefixIcon: Icon(Icons.account_circle_outlined),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            validator: (value) {
              // กรณีไม่กรอกสัญชาติ
              if (value!.isEmpty) {
                return "กรุณากรอกสัญชาติของคุณ";
              }
              //กรณีเพศไม่ถูกต้อง
            },
          ),
        ),
      ],
    );
  }

  Row buildgender(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: GenderTextController,
            decoration: InputDecoration(
              labelText: "เพศ",
              prefixIcon: Icon(Icons.account_circle_outlined),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            validator: (value) {
              // ตรวจสอบความถูกต้องของเพศ
              bool isgenderValid = RegExp(r'^[ก-๙]{3,5}$').hasMatch(value!);

              // กรณีไม่กรอกเพศ
              if (value.isEmpty) {
                return "กรุณากรอกเพศของคุณ";
              }
              //กรณีเพศไม่ถูกต้อง
              else if (!isgenderValid) {
                return "กรุณากรอกเพศของคุณเป็นภาษาไทยเท่านั้น";
              }
            },
          ),
        ),
      ],
    );
  }

  Row buildage(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: AgeTextController,
            decoration: InputDecoration(
              labelText: "อายุ",
              prefixIcon: Icon(Icons.account_circle_outlined),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            validator: (value) {
              // ตรวจสอบความถูกต้องของอายุ
              bool isageValid = RegExp(r'^[0-9]{2,3}$').hasMatch(value!);

              // กรณีไม่กรอกอายุ
              if (value.isEmpty) {
                return "กรุณากรอกอายุของคุณ";
              }
              //อายุไม่ถูกต้อง
              else if (!isageValid) {
                return "กรุณากรอกอายุให้ถูกต้อง";
              }
            },
          ),
        ),
      ],
    );
  }

  Row buildfullname(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: fullnameTextController,
            decoration: InputDecoration(
              labelText: "fullname",
              prefixIcon: Icon(Icons.account_circle_outlined),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            validator: (value) {
              // ตรวจสอบความถูกต้องของชื่อ-นามสกุล
              bool isfullnameValid = RegExp(r'^[ก-์," "]{2,30}$').hasMatch(value!);

              // กรณีไม่กรอกชื่อ-นามสกุล
              if (value.isEmpty) {
                return "กรุณากรอกชื่อ-นามสกุล เป็นภาษาไทย";
              }
              // กรณีชื่อ-นามสกุลไม่ถูกต้อง
              else if (!isfullnameValid) {
                return "ชื่อ-นามสกุลไม่ถูกต้อง";
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
            controller: passwordTextController,
            decoration: InputDecoration(
              labelText: "รหัสผ่าน",
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
              bool isPasswordValid  = RegExp(r'^[A-Za-z0-9]{1,8}$').hasMatch(value!);
              // bool isPasswordValid = RegExp(r'^[0-9]{4}$').hasMatch(value!);

              // กรณีไม่กรอกรหัสผ่าน
              if (value.isEmpty) {
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

  Row buildusername(double size) {
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
              bool usernameValid = RegExp(
                      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])[A-Za-z0-9]{4,16}$')
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

  Row buildappname() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Text(
            "สร้างบัญชีผู้ใช้",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }
}
