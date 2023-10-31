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

  var typegender  = TypeGender.male;
  String? typegenders;

  // String? validateGender(TypeGender? value) {
  //   if (value == null) {
  //     return 'กรุณาเลือกเพศ';
  //   }
  //   return null;
  // }

  String? validateUsername(String? value) {
    bool usernameValid =
        RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])[A-Za-z0-9]{4,16}$')
            .hasMatch(value!);

    if (value.isEmpty) {
      return "กรุณากรอกชื่อผู้ใช้";
    } else if (!usernameValid) {
      return "ชื่อผู้ใช้ต้องประกอบด้วยตัวอักษร A-Z, a-z, และตัวเลข 0-9";
    }
    return null;
  }

  String? validatePassword(String? value) {
    bool isPasswordValid =
        RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])[A-Za-z0-9]{8,}$')
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
                buildbuttom(size),
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
        ),
        validator: validator, // ใช้ validator ที่ถูกส่งเข้ามา
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
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "กรุณาเลือกวันที่";
          }
          return null;
        },
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
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            onPressed: () async {
              String? validationMessage;

              if (typegender == null) {
                validationMessage = 'โปรดเลือกเพศก่อนที่จะดำเนินการต่อ';
              } else if (!formkey.currentState!.validate()) {
                validationMessage = 'โปรดกรอกข้อมูลให้ครบถ้วน';
              }
              if (validationMessage != null) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('แจ้งเตือน'),
                      content: Text(validationMessage!),
                      actions: <Widget>[
                        TextButton(
                          child: Text('ตกลง'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );
              } else {
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
                      content: Text('สร้างบัญชีสำเร็จ!'),
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
              }
            },
            child: Text("สร้างบัญชี"),
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
              bool isEmailValid =
                  RegExp(r"^(?=.*[A-Za-z0-9@._-])[A-Za-z0-9@._-]{5,60}$")
                      .hasMatch(value!);

              if (value.isEmpty) {
                return "กรุณากรอกอีเมลล์ของคุณ";
              } else if (!isEmailValid) {
                return "กรุณากรอกอีเมลล์ของคุณให้ถูกต้อง";
              }
              return null;
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
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now());
              if (tempDate != null) {
                setState(() {
                  birthday = tempDate;
                  String formattedDate =
                      DateFormat('dd/MM/yyyy').format(birthday!);
                  birthdayTextController.text = formattedDate;
                  age = DateTime.now().year - birthday!.year;
                  AgeTextController.text = age.toString();
                  checkage = true;
                });
              }
            },
            readOnly: true,
            controller: birthdayTextController,
            decoration: InputDecoration(
              labelText: "วัน/เดือน/ปีเกิด",
              prefixIcon: Icon(Icons.calendar_today_outlined),
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
              return null;
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
              prefixIcon: Icon(Icons.phone_outlined),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            validator: (value) {
              bool isMobileValid =
                  RegExp(r'^(06|08|09)[0-9]{8}$').hasMatch(value!);

              if (value.isEmpty) {
                return "กรุณากรอกหมายเลขโทรศัพท์ของคุณ";
              } else if (!isMobileValid) {
                return "กรุณากรอกหมายเลขโทรศัพท์ของคุณให้ถูกต้อง\n (06/08/09)";
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget buildGenderField() {
    return Column(
      children: <Widget>[
        RadioListTile<TypeGender>(
          title: Text('ชาย'),
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
          title: Text('หญิง'),
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
              prefixIcon: Icon(Icons.credit_card_outlined),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            validator: (value) {
              bool isIdcardValid = RegExp(r'^[0-9]{13}$').hasMatch(value!);

              if (value.isEmpty) {
                return "กรุณากรอกเลขบัตรประชาชน 13 หลักของคุณ";
              } else if (!isIdcardValid) {
                return "กรุณากรอกเลขบัตรประชาชน 13 หลักของคุณเป็นตัวเลขเท่านั้น";
              }
              return null;
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
              if (value!.isEmpty) {
                return "กรุณากรอกสัญชาติของคุณ";
              }
              return null;
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
          child: buildCheckage(),
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
              labelText: "ชื่อ - นามสกุล ",
              prefixIcon: Icon(Icons.account_circle_outlined),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            validator: (value) {
              bool isfullnameValid =
                  RegExp(r'^[ก-์," "]{2,30}$').hasMatch(value!);

              if (value.isEmpty) {
                return "กรุณากรอกชื่อ-นามสกุล เป็นภาษาไทย";
              } else if (!isfullnameValid) {
                return "ชื่อ-นามสกุลไม่ถูกต้อง";
              }
              return null;
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
            obscureText: true,
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
              bool isPasswordValid =
                  RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])[A-Za-z0-9]{8,}$')
                      .hasMatch(value!);

              if (value.isEmpty) {
                return "กรุณากรอกรหัสผ่าน";
              } else if (!isPasswordValid) {
                return "รหัสผ่านต้องประกอบด้วย\n ตัวอักษร A-Z, a-z, และตัวเลข 0-9";
              }
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
              labelText: "ชื่อผู้ใช้",
              prefixIcon: Icon(Icons.account_circle_outlined),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            validator: (value) {
              bool usernameValid = RegExp(
                      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])[A-Za-z0-9]{4,16}$')
                  .hasMatch(value!);

              if (value.isEmpty) {
                return "กรุณากรอกชื่อผู้ใช้";
              } else if (!usernameValid) {
                return "ชื่อผู้ใช้ต้องประกอบด้วย\n ตัวอักษร A-Z, a-z, และตัวเลข 0-9";
              }
              return null;
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
                  title: Text("Error"),
                  content: Text("You must be 18 years or older."),
                  actions: <Widget>[
                    TextButton(
                      child: Text("OK"),
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
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
