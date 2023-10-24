import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pet_insurance/controller/OfficerController.dart';
import 'package:pet_insurance/model/Petinsuranceregister.dart';
import 'package:pet_insurance/screen/Listinsurance.dart';

import '../controller/MemberController.dart';
import '../controller/PaymentController.dart';
import '../model/Member.dart';
import 'View_insurance.dart';

class Payments extends StatefulWidget {
  final int insurance_regId;
  final String substring;
  const Payments(
      {super.key, required this.insurance_regId, required this.substring});

  @override
  State<Payments> createState() => _PaymentsState();
}

String? user;
Member? member;
Petinsuranceregister? petinsuranceregister;
bool? isLoaded;
File? _images;
final GlobalKey<FormState> formKey = GlobalKey<FormState>();
final MemberController memberController = MemberController();
final OfficerController officerController = OfficerController();
final PaymentController paymentController = PaymentController();

class _PaymentsState extends State<Payments> {
  Future getImage() async {
    final picker = ImagePicker();
    var images = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _images = File(images!.path);
    });
  }

  void factdata(int insurance_regId) async {
    user = await SessionManager().get("username");
    member = await memberController.getMemberById(user!);
    print("testusername ${member?.username?.username}");
    print(user);
    print(insurance_regId);
    var response = await officerController.getInsuranceregById(insurance_regId);
    petinsuranceregister = Petinsuranceregister.fromJsonToPetregister(response);
    setState(() {
      isLoaded = false;
    });
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    factdata(widget.insurance_regId);
  }

  String Policynumber() {
    // สร้าง Object จากคลาส Random สำหรับการสุ่มเลข
    Random random = Random();
    String subdate = "";
    if (petinsuranceregister?.enddate != null) {
      subdate = DateFormat('ddMMyyyy').format(petinsuranceregister!.enddate!);
      // ทำสิ่งที่คุณต้องการกับ dateFormat ที่ได้
    }
    DateTime currentDate = DateTime.now();

    // สร้าง INS และตัวเลขสุ่มที่มีความยาว 6 หลัก
    String ins = 'INS';
    String? randomNumbers =
        "$subdate${petinsuranceregister?.petdetail?.petId}"; // เลขสุ่มระหว่าง 100000 ถึง 999999

    // นำ INS และเลขสุ่มมาต่อกันเป็นข้อความเต็ม
    String policyNumber = '$ins$randomNumbers';

    // พิมพ์เลขกรรมธรรม์
    print('เลขกรรมธรรม์: $policyNumber');
    return policyNumber;
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("สรุปความคุ้มครองและชำระเงิน"),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return ListInsurance();
            }));
          },
        ),
      ),
      body: Form(
          key: formKey,
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 200),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "เพิ่มรูปภาพสลิป",
                        style: TextStyle(
                          fontWeight: FontWeight.bold, // ตั้งค่าให้ตัวหนา
                          fontSize: 20, // ตั้งค่าขนาดฟอนต์เป็น 24
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _images == null
                          ? Text('No image selected.')
                          : Image.file(
                              _images!,
                              height: 100,
                            ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        onPressed: getImage,
                        child: Text('Select Image'),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "ราคาทั้งหมด",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text("${widget.substring}")
                    ],
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.symmetric(vertical: 16),
                  width: size * 0.6,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30))),
                      onPressed: () async {
                        print(widget.insurance_regId);
                        http.Response response =
                            await paymentController.addimgPayment(
                          widget.insurance_regId.toString(),
                          widget.substring,
                          Policynumber(),
                          _images!,
                        );
                        if (response.statusCode == 200) {
                          print("Error!");
                        } else {
                          print("Member was Payment successfully!");
                        }
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (BuildContext context) {
                          return Viewinsurance();
                        }));
                      },
                      child: Text("ชำระเงิน"))),
            ],
          )),
    ));
  }
}
