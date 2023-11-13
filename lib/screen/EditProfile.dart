import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pet_insurance/model/Member.dart';
import 'package:pet_insurance/screen/ShowProfile.dart';
import 'package:pet_insurance/screen/View_insurance.dart';
import 'package:quickalert/quickalert.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../controller/MemberController.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

enum TypeGender { male, female }

class _EditProfileState extends State<EditProfile> {
  String? user;
  Member? member;
  bool? isLoaded;

  String? substring;
  int? age;
  bool checkage = false;

  var dateFormat = DateFormat('dd-MM-yyyy');
  DateTime currentDate = DateTime.now();
  DateTime? birthday;

  var typegender = TypeGender.male;
  String? typegenders = "ชาย";

  final MemberController memberController = MemberController();
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

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
  TextEditingController usernameController = TextEditingController();

  void fetcData() async {
    user = await SessionManager().get("username");
    print(user);
    member = await memberController.getMemberById(user!);
    print("testusername ${member?.username?.username}");
    setState(() {
      fullnameTextController.text = member?.fullname ?? "";
      AgeTextController.text = member?.age ?? "";
      GenderTextController.text = member?.gender ?? "";
      nationalityTextController.text = member?.nationality ?? "";
      MobilenumberTextController.text = member?.mobileno ?? "";
      EmailTextController.text = member?.member_email ?? "";
      IdCardTextController.text = member?.idcard ?? "";
      AdddressTextController.text = member?.address ?? "";
      IDlineTextController.text = member?.id_line ?? "";
      birthdayTextController.text =
          dateFormat.format(member?.brithday ?? DateTime.now());
      isLoaded = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetcData();
  }

  void showSureToUpdateMemberAlert(Member uMember) {
    QuickAlert.show(
        context: context,
        title: "คุณแน่ใจหรือไม่ ? ",
        text: "คุณต้องการอัพเดทข้อมูลสมาชิกหรือไม่ ? ",
        type: QuickAlertType.warning,
        confirmBtnText: "ใช่",
        onConfirmBtnTap: () async {
          http.Response response = await memberController.updateMember(uMember);

          if (response.statusCode == 200) {
            Navigator.pop(context);
            showUpdateMemberSuccessAlert();
          } else {
            showFailToUpdateMemberAlert();
          }
        },
        cancelBtnText: "ไม่",
        showCancelBtn: true);
  }

  void showFailToUpdateMemberAlert() {
    QuickAlert.show(
        context: context,
        title: "เกิดข้อผิดพลาด",
        text: "ไม่สามารถอัพเดทข้อมูลสมาชิกได้",
        type: QuickAlertType.error);
  }

  void showUpdateMemberSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: "สำเร็จ",
        text: "อัพเดทข้อมูลสำเร็จ",
        type: QuickAlertType.success,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ShowProfile()));
        });
  }

  String? validateUsername(String? value) {
    bool usernameValid =
        RegExp(r'^(?=.*[A-Z])(?=.*[a-z])[a-zA-Z0-9]{4,16}$').hasMatch(value!);

    if (value.isEmpty) {
      return "กรุณากรอกชื่อผู้ใช้";
    } else if (value.length < 4) {
      return "กรุณากรอกข้อมูลให้มีอย่างน้อย 4 ตัวอักษร";
    } else if (!usernameValid) {
      return "ชื่อผู้ใช้ต้องประกอบด้วยตัวอักษร A-Z, a-z, และตัวเลข 0-9";
    }
    return null;
  }

  String? validatePassword(String? value) {
    bool isPasswordValid =
        RegExp(r'^[a-zA-Z0-9]{8,}$')
            .hasMatch(value!);

    if (value.isEmpty) {
      return "กรุณากรอกรหัสผ่าน";
    } else if (!isPasswordValid) {
      return "รหัสผ่านต้องประกอบด้วย\n ตัวอักษร A-Z, a-z, และตัวเลข 0-9";
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
        title: const Text("ข้อมูลส่วนตัว",style: TextStyle(fontFamily: "Itim"),),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return ShowProfile();
            }));
          },
        ),
      ),
      body:isLoaded == false ? SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    "แก้ไขข้อมูลส่วนตัว",
                    style: TextStyle(fontSize: 20,fontFamily: "Itim"),
                  ),
                ),
                SizedBox(height: 30),
                buildInputField("ชื่อ - นามสกุล", Icons.account_circle_outlined,
                    fullnameTextController,
                    validator: validateFullname),
                buildGenderField(),
                buildInputField("สัญชาติ", Icons.account_circle_outlined,
                    nationalityTextController,
                    validator: validatenationality),
                buildInputFieldnumber("บัตรประชาชน 13 หลัก",
                    Icons.credit_card_outlined, IdCardTextController,
                    validator: validateIDcard),
                buildInputFieldmobile("หมายเลขโทรศัพท์", Icons.phone_outlined,
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
                buildbuttom(size),
              ],
            ),
          ),
        ),
      ):CircularProgressIndicator(),
    );
  }

  Widget buildInputFieldmobile(
      String labelText, IconData icon, TextEditingController controller,
      {bool obscureText = false, String? Function(String?)? validator}) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: TextFormField(
        maxLength: 10,
        controller: controller,
        obscureText: obscureText,
        keyboardType: TextInputType.number,
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

  Widget buildInputFieldnumber(
      String labelText, IconData icon, TextEditingController controller,
      {bool obscureText = false, String? Function(String?)? validator}) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: TextFormField(
        maxLength: 13,
        controller: controller,
        obscureText: obscureText,
        keyboardType: TextInputType.number,
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
        ),
        validator: validator, // ใช้ validator ที่ถูกส่งเข้ามา
      style: TextStyle(fontFamily: "Itim"),),
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
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "กรุณาเลือกวันที่";
          }
          return null;
        },
      style: TextStyle(fontFamily: "Itim"),),
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
                  Member updateMember = Member(
                      memberId: member?.memberId,
                      age: AgeTextController.text,
                      mobileno: MobilenumberTextController.text,
                      member_email: EmailTextController.text,
                      gender: GenderTextController.text,
                      fullname: fullnameTextController.text,
                      idcard: IdCardTextController.text,
                      address: AdddressTextController.text,
                      brithday: dateFormat.parse(birthdayTextController.text),
                      nationality: nationalityTextController.text,
                      id_line: IDlineTextController.text,
                      username: member?.username);
                  // print(updateMember?.username?.username);
                  showSureToUpdateMemberAlert(updateMember);
                },
                child: Text("แก้ไขข้อมูล",style: TextStyle(fontFamily: "Itim"),))),
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
              borderRadius: BorderRadius.circular(30)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.cyan),
              borderRadius: BorderRadius.circular(30)),
        ),
        validator: (value) {
          if (age! < 18) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("แจ้งเตือน",style: TextStyle(fontFamily: "Itim"),),
                  content: Text("ต้องมีอายุมากกว่า 18 ปี",style: TextStyle(fontFamily: "Itim"),),
                  actions: <Widget>[
                    TextButton(
                      child: Text("ตกลง",style: TextStyle(fontFamily: "Itim"),),
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
      style: TextStyle(fontFamily: "Itim"),);
    } else {
      return const SizedBox.shrink();
    }
  }

  buildGenderField() {
    return Column(
      children: <Widget>[
        RadioListTile<TypeGender>(
          title: Text('ชาย',style: TextStyle(fontFamily: "Itim"),),
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
          title: Text('หญิง',style: TextStyle(fontFamily: "Itim"),),
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
}
