import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../controller/MemberController.dart';
import '../controller/PaymentController.dart';
import '../model/Member.dart';
import 'View_insurance.dart';

class Payment extends StatefulWidget {
  final int insurance_regId;
  const Payment({super.key, required this.insurance_regId});

  @override
  State<Payment> createState() => _PaymentState();
}

String? user;
Member? member;
bool? isLoaded;
File? _images;
final GlobalKey<FormState> formKey = GlobalKey<FormState>();
final MemberController memberController = MemberController();
final PaymentController paymentController = PaymentController();

class _PaymentState extends State<Payment> {

  Future getImage() async {
    final picker = ImagePicker();
    var images = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _images = File(images!.path);
    });
  }

  void factdata() async {

    user = await SessionManager().get("username");
    member = await memberController.getMemberById(user!);
    print("testusername ${member?.username?.username}");
    print(user);
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
    factdata();
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
              return Viewinsurance();
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
                  padding: EdgeInsets.only(top: 250),
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
                         http.Response response = await paymentController.addimgPayment(
                          widget.insurance_regId.toString(),
                          // "",
                          // "",
                          _images!,
                          
                  );
                  if (response.statusCode == 200) {
                    print("Error!");
                  } else {
                    print("Member was added successfully!");
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
