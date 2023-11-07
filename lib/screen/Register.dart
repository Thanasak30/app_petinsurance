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

enum TypeGender { male, female }

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

  String? substring;
  int? age;
  bool checkage = false;
  bool checkgender = false;
  bool isLode = false;

  var typegender = TypeGender.male;
  String? typegenders = "ชาย";

  bool? checkvalidate = false;

  String? validateUsername(String? value) {
    bool usernameValid =
        RegExp(r'^(?=.*[A-Z])(?=.*[a-z])[a-zA-Z0-9]{4,16}$').hasMatch(value!);

    if (value.isEmpty) {
      return "กรุณากรอกชื่อผู้ใช้";
    } else if (value.length < 4) {
      return "กรุณากรอกข้อมูลให้มีอย่างน้อย 4 ตัวอักษร";
    } else if (!usernameValid) {
      return "ชื่อผู้ใช้ต้องประกอบด้วยตัวอักษร A-Z, a-z";
    }
    return null;
  }

  String? validatePassword(String? value) {
    bool isPasswordValid = RegExp(r'^[a-zA-Z0-9]{8,}$').hasMatch(value!);

    if (value.isEmpty) {
      return "กรุณากรอกรหัสผ่าน";
    } else if (!isPasswordValid) {
      return "รหัสผ่านต้องประกอบด้วย\n ตัวอักษรภาษาอังกฤษ และตัวเลข 0-9";
    } else if (!isPasswordValid == "") {
      return "ห้ามมีค่าว่าง";
    }
    return null;
  }

  String? validateFullname(String? value) {
    bool isfullnameValid = RegExp(r'^[ก-์," "]{2,30}$').hasMatch(value!);

    if (value.isEmpty) {
      return "กรุณากรอกชื่อ-นามสกุล เป็นภาษาไทย";
    } else if (!isfullnameValid) {
      return "ชื่อ-นามสกุลไม่ถูกต้อง";
    }
    return null;
  }

  String? validatenationality(String? value) {
    if (value!.isEmpty) {
      return "กรุณากรอกสัญชาติของคุณ";
    }
    return null;
  }

  String? validateIDcard(String? value) {
    bool isIdcardValid = RegExp(r'^[0-9]{13}$').hasMatch(value!);

    if (value.isEmpty) {
      return "กรุณากรอกเลขบัตรประชาชน 13 หลักของคุณ";
    } else if (!isIdcardValid) {
      return "กรุณากรอกเลขบัตรประชาชน 13 หลักของคุณเป็นตัวเลขเท่านั้น";
    }
    return null;
  }

  String? validatemobile(String? value) {
    bool isMobileValid = RegExp(r'^(06|08|09)[0-9]{8}$').hasMatch(value!);

    if (value.isEmpty) {
      return "กรุณากรอกหมายเลขโทรศัพท์ของคุณ";
    } else if (!isMobileValid) {
      return "กรุณากรอกหมายเลขโทรศัพท์ของคุณให้ถูกต้อง\n (06/08/09)";
    }
    return null;
  }

  String? validateemail(String? value) {
    bool isEmailValid = RegExp(r"^(?=.*[A-Za-z0-9@._-])[A-Za-z0-9@._-]{5,60}$")
        .hasMatch(value!);

    if (value.isEmpty) {
      return "กรุณากรอกอีเมลล์ของคุณ";
    } else if (!isEmailValid) {
      return "กรุณากรอกอีเมลล์ของคุณให้ถูกต้อง";
    }
    return null;
  }

  String? validateidline(String? value) {
    if (value!.isEmpty) {
      return "กรุณากรอกไอดีไลน์ของคุณ";
    }
    return null;
  }

  String? validateaddress(String? value) {
    if (value!.isEmpty) {
      return "กรุณากรอกที่อยู่ของคุณ";
    }
    return null;
  }

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    "สร้างบัญชีผู้ใช้",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(height: 30),
                buildInputField("ชื่อผู้ใช้", Icons.account_circle_outlined,
                    userNameTextController,
                    validator: validateUsername),
                buildInputField(
                    "รหัสผ่าน", Icons.lock_outline, passwordTextController,
                    obscureText: true, validator: validatePassword),
                buildInputField("ชื่อ - นามสกุล", Icons.account_circle_outlined,
                    fullnameTextController,
                    validator: validateFullname),
                buildGenderField(),
                buildInputField("สัญชาติ", Icons.account_circle_outlined,
                    nationalityTextController,
                    validator: validatenationality),
                buildInputField("บัตรประชาชน 13 หลัก",
                    Icons.credit_card_outlined, IdCardTextController,
                    validator: validateIDcard),
                buildInputField("หมายเลขโทรศัพท์", Icons.phone_outlined,
                    MobilenumberTextController,
                    validator: validatemobile),
                buildDatePickerField("วัน/เดือน/ปีเกิด",
                    Icons.calendar_today_outlined, birthdayTextController),
                buildCheckage(),
                buildInputField(
                    "อีเมลล์", Icons.email_outlined, EmailTextController,
                    validator: validateemail),
                buildInputField("ที่อยู่", Icons.location_on_outlined,
                    AdddressTextController,
                    validator: validateaddress),
                buildInputField("ไอดีไลน์", Icons.account_circle_outlined,
                    IDlineTextController,
                    validator: validateidline),
                buildButton(size),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInputField(
      String labelText, IconData icon, TextEditingController controller,
      {bool obscureText = false, String? Function(String?)? validator}) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: Icon(icon),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyan),
              borderRadius: BorderRadius.circular(30),
            ),
            // ถ้า validator คืนค่าไม่เป็น null ให้ใช้ errorBorder และ errorStyle
            errorBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(color: Colors.red), // สีขอบเมื่อข้อมูลไม่ถูกต้อง
              borderRadius: BorderRadius.circular(30),
            ),
            errorStyle: TextStyle(color: Colors.red),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.red), // กำหนดสีของกรอบเมื่อมีข้อความข้อผิดพลาด
              borderRadius: BorderRadius.circular(30),
            ) // สีข้อความเมื่อข้อมูลไม่ถูกต้อง // สีข้อความเมื่อข้อมูลไม่ถูกต้อง
            ),
        validator: validator,
        style: TextStyle(fontFamily: "Itim"),
      ),
    );
  }

  Widget buildDatePickerField(
      String labelText, IconData icon, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: TextFormField(
        onTap: () async {
          DateTime? tempDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1950),
            lastDate: DateTime.now(),
          );
          if (tempDate != null) {
            setState(() {
              birthday = tempDate;
              String formattedDate = DateFormat('dd-MM-yyyy').format(birthday!);
              controller.text = formattedDate;
              age = DateTime.now().year - birthday!.year;
              AgeTextController.text = age.toString();
              checkage = true;
            });
          }
        },
        readOnly: true,
        controller: controller,
        decoration: InputDecoration(
            labelText: labelText,
            prefixIcon: Icon(icon),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(30),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyan),
              borderRadius: BorderRadius.circular(30),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color:
                      Colors.red), // กำหนดสีของกรอบเมื่อมีข้อความข้อผิดพลาดแสดง
              borderRadius: BorderRadius.circular(30),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.red), // กำหนดสีของกรอบเมื่อมีข้อความข้อผิดพลาด
              borderRadius: BorderRadius.circular(30),
            ) // สีข้อความเมื่อข้อมูลไม่ถูกต้อง// สีข้อความเมื่อข้อมูลไม่ถูกต้อง
            ),
        style: TextStyle(fontFamily: "Itim"),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "กรุณาเลือกวันที่";
          }
          return null;
        },
      ),
    );
  }

  Row buildButton(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 16),
          width: size * 0.6,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () async {
              if (formkey.currentState!.validate()) {
                // กรุณากรอกข้อมูลให้ครบถ้วนก่อนทำการสร้างบัญชี
                http.Response response = await memberController.addMember(
                  birthdayTextController.text,
                  AdddressTextController.text,
                  AgeTextController.text,
                  fullnameTextController.text,
                  typegenders.toString(),
                  IDlineTextController.text,
                  IdCardTextController.text,
                  EmailTextController.text,
                  MobilenumberTextController.text,
                  nationalityTextController.text,
                  passwordTextController.text,
                  userNameTextController.text,
                );
                if (response.statusCode == 500) {
                  print("Error!");
                } else {
                  print("Member was added successfully!");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.green,
                      content: Text(
                        'สร้างบัญชีสำเร็จ!',
                        style:
                            TextStyle(fontFamily: "Itim", color: Colors.white),
                      ),
                    ),
                  );
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) {
                        return LoginScreen();
                      },
                    ),
                  );
                }
              } else {
                // แสดงข้อความเมื่อข้อมูลไม่ครบถ้วน
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(
                      'โปรดกรอกข้อมูลให้ครบถ้วน',
                      style: TextStyle(fontFamily: "Itim", color: Colors.white),
                    ),
                  ),
                );
              }
            },
            child: Text("สร้างบัญชี", style: TextStyle(fontFamily: "Itim")),
          ),
        ),
      ],
    );
  }

  Widget buildGenderField() {
    return Column(
      children: <Widget>[
        RadioListTile<TypeGender>(
          title: Text(
            'ชาย',
            style: TextStyle(fontFamily: "Itim"),
          ),
          value: TypeGender.male,
          groupValue: typegender,
          onChanged: (TypeGender? value) {
            setState(() {
              typegender = TypeGender.male;
              typegenders = "ชาย";
            });
          },
        ),
        RadioListTile<TypeGender>(
          title: Text('หญิง', style: TextStyle(fontFamily: "Itim")),
          value: TypeGender.female,
          groupValue: typegender,
          onChanged: (TypeGender? value) {
            setState(() {
              typegender = TypeGender.female;
              typegenders = "หญิง";
            });
          },
        ),
      ],
    );
  }

  Widget buildCheckage() {
  if (checkage) {
    return TextFormField(
      controller: AgeTextController,
      enabled: false,
      decoration: InputDecoration(
        labelText: "อายุ",
        prefixIcon: Icon(Icons.account_circle_outlined),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(30),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red), // สีของเส้นเมื่อมีข้อผิดพลาด
          borderRadius: BorderRadius.circular(30),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red), // สีของเส้นเมื่อมีข้อผิดพลาดเมื่อโฟกัส
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      validator: (value) {
        if (age! < 18) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "แจ้งเตือน!!!",
                  style: TextStyle(fontFamily: "Itim"),
                ),
                content: Text("อายุต้องมากกว่า 18 ปี",
                    style: TextStyle(fontFamily: "Itim")),
                actions: <Widget>[
                  TextButton(
                    child: Text("ตกลง", style: TextStyle(fontFamily: "Itim")),
                    onPressed: () {
                      setState(() {
                        birthday = null;
                        birthdayTextController.clear();
                        age = 0;
                      });
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
        return null;
      },
      style: TextStyle(fontFamily: "Itim"),
    );
  } else {
    return const SizedBox.shrink();
  }
}

}
