import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
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
      {Key? key, required this.insurance_regId, required this.substring})
      : super(key: key);

  @override
  State<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends State<Payments> {
  String? user;
  Member? member;
  Petinsuranceregister? petinsuranceregister;
  File? _images;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final MemberController memberController = MemberController();
  final OfficerController officerController = OfficerController();
  final PaymentController paymentController = PaymentController();

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
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    factdata(widget.insurance_regId);
  }

  String Policynumber() {
    Random random = Random();
    String subdate =
        DateFormat('ddMMyyyy').format(petinsuranceregister!.enddate!);
    String ins = 'INS';
    String randomNumbers =
        "$subdate${petinsuranceregister?.petdetail?.petId ?? ''}";
    String policyNumber = '$ins$randomNumbers';
    print('เลขกรรมธรรม์: $policyNumber');
    return policyNumber;
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("สรุปความคุ้มครองและชำระเงิน",
              style: TextStyle(fontFamily: "Itim")),
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
                  return ListInsurance();
                }),
              );
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
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          fontFamily: "Itim",
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _images == null
                          ? Text('เพิ่มรูปภาพ.',
                              style: TextStyle(fontFamily: "Itim"))
                          : Image.file(
                              _images!,
                              height: 100,
                            ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: getImage,
                        child: Text(
                          'เลือกรูปภาพ',
                          style: TextStyle(fontFamily: "Itim"),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "ราคาทั้งหมด",
                        style: TextStyle(fontSize: 18, fontFamily: "Itim"),
                      ),
                      Text(
                        "${widget.substring}",
                        style: TextStyle(fontFamily: "Itim"),
                      ),
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
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    if (_images == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'กรุณาเลือกรูปภาพ',
                            style: TextStyle(
                                fontFamily: "Itim", color: Colors.white),
                          ),
                          duration: Duration(seconds: 3),
                        ),
                      );
                    } else {
                      http.Response response =
                          await paymentController.addimgPayment(
                        widget.insurance_regId.toString(),
                        widget.substring,
                        Policynumber(),
                        _images!,
                      );
                      if (response.statusCode == 200) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              'ทำการชำระเงินเรียบร้อยแล้ว!',
                              style: TextStyle(
                                  fontFamily: "Itim", color: Colors.white),
                            ),
                            duration: Duration(seconds: 3),
                          ),
                        );
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Viewinsurance();
                            },
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'เกิดข้อผิดพลาด กรุณาลองอีกครั้ง',
                              style: TextStyle(
                                  fontFamily: "Itim", color: Colors.white),
                            ),
                            duration: Duration(seconds: 3),
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    "ชำระเงิน",
                    style: TextStyle(fontFamily: "Itim"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
