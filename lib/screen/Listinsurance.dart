import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:pet_insurance/controller/PaymentController.dart';
import 'package:pet_insurance/model/Payment.dart';
import 'package:pet_insurance/screen/insurance_reg5.dart';

import '../controller/MemberController.dart';
import '../controller/OfficerController.dart';
import '../controller/PetdetailController.dart';
import '../model/Insurancedetail.dart';
import '../model/Member.dart';
import '../model/Petdetail.dart';
import '../model/Petinsuranceregister.dart';
import 'View_insurance.dart';

class ListInsurance extends StatefulWidget {
  const ListInsurance({super.key, Key});

  @override
  State<ListInsurance> createState() => _ListInsuranceState();
}

class _ListInsuranceState extends State<ListInsurance> {
  final PetdetailController petdetailController = PetdetailController();
  final MemberController memberController = MemberController();
  final OfficerController officerController = OfficerController();
  final PaymentController paymentController = PaymentController();

  List<Insurancedetail>? insurancedetail;
  List<Petinsuranceregister>? petinsuranceregister;

  Petdetail? petdetail;
  Member? member;
  String? user;
  Payment? payment;
  List<Payment>? payments;
  bool check = false;
  DateTime now = DateTime.now();

  Duration? checkdate;
  int? differancedate;
  var dateFormat = DateFormat('dd-MM-yyyy');

  bool? isLoade = false;
  void fetcData() async {
    setState(() {
      isLoade = false;
    });
    user = await SessionManager().get("username");
    print(user);
    member = await memberController.getMemberById(user!);

    petinsuranceregister = await officerController
        .listInsurance(member?.memberId.toString() ?? "");

    setState(() {
      isLoade = true;
    });
  }

  void PaymentData() async {
    payments = await paymentController.listAllpayment();
    print("payments  :  ${payments}");
    setState(() {
      payments?.forEach((element) {
        print(element.status);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    PaymentData();
    fetcData();
  }

  @override
  Widget build(BuildContext context) {
    dateFormat.format(now);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text("รายการที่ทำประกัน"),
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
          body: isLoade == true
              ? ListView.builder(
                  itemCount: petinsuranceregister?.length ??
                      0, // กำหนดให้ itemCount เป็น 0 ถ้า petdetail เป็น null
                  itemBuilder: (context, index) {
                    var petName =
                        petinsuranceregister?[index].petdetail?.namepet ?? "";
                    var memberName = member?.fullname;
                    var startdate = dateFormat.format(
                        petinsuranceregister?[index].startdate ??
                            DateTime.now());
                    var enddate = dateFormat.format(
                        petinsuranceregister?[index].enddate as DateTime);
                    var status = petinsuranceregister?[index].status ?? "";
                    var statuspayment = (payments != null &&
                            index >= 0 &&
                            index < payments!.length)
                        ? payments![index].status ?? ""
                        : "";
                    DateTime Enddate =
                        petinsuranceregister?[index].enddate as DateTime;

                    Color getStatusColor(String status) {
                      switch (status) {
                        case 'อนุมัติ':
                          return Colors.green;
                        case 'รอดำเนินการ':
                          return Colors.blueGrey;
                        case 'ไม่อนุมัติ':
                          return Colors.red;
                        default:
                          return Colors
                              .red; // สีเริ่มต้นถ้าไม่ตรงกับเงื่อนไขใด ๆ
                      }
                    }

                    checkdate = petinsuranceregister?[index]
                        .enddate
                        ?.difference(DateTime.now());
                    differancedate = checkdate?.inDays;
                    differancedate = differancedate! + 1;
                    print(
                        "Date: ${dateFormat.format(petinsuranceregister?[index].enddate as DateTime)}");

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Card(
                        elevation: 10,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ชื่อสัตว์เลี้ยง: $petName",
                                style: TextStyle(fontFamily: "Itim"),
                              ),
                              Text(
                                "ชื่อเจ้าของ: $memberName",
                                style: TextStyle(fontFamily: "Itim"),
                              ),
                              Text(
                                "วันที่เริ่มต้นคุ้มครอง: $startdate",
                                style: TextStyle(fontFamily: "Itim"),
                              ),
                              Text(
                                "วันสิ้นสุดการคุ้มครอง:  $enddate",
                                style: TextStyle(fontFamily: "Itim"),
                              ),
                              Text(
                                "สถานะ: $status",
                                style: TextStyle(
                                  fontFamily: "Itim",
                                  color: getStatusColor(status),
                                ),
                              ),
                              Text(
                                Enddate.isBefore(now)
                                    ? "หมดอายุ"
                                    : (status == "อนุมัติ" &&
                                            statuspayment == "ชำระเงินแล้ว")
                                        ? statuspayment
                                        : (status == "อนุมัติ" &&
                                                statuspayment != "ชำระเงินแล้ว")
                                            ? "กรุณาทำการชำระเงิน"
                                            : "",
                                style: TextStyle(
                                  fontFamily: "Itim",
                                  color: (status == "อนุมัติ" &&
                                          statuspayment != "ชำระเงินแล้ว")
                                      ? Colors.blueAccent
                                      : Enddate.isBefore(now)
                                          ? Colors.red
                                          : (status == "อนุมัติ" &&
                                                  statuspayment ==
                                                      "ชำระเงินแล้ว")
                                              ? getStatusColor(status)
                                              : Colors.red,
                                ),
                              )
                            ],
                          ),
                          onTap: () {
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                              builder: (_) => InsuranceREG5(
                                pet_id: (petinsuranceregister?[index]
                                        .petdetail
                                        ?.petId)
                                    .toString(),
                                insurance_planId: (petinsuranceregister?[index]
                                        .insurancedetail
                                        ?.insurance_planId ??
                                    0),
                                insurance_regId: (petinsuranceregister?[index]
                                        .insurance_regId ??
                                    0),
                              ),
                            ));
                          },
                        ),
                      ),
                    );
                  },
                )
              : Center(
                  child: Text(
                  "ไม่มีข้อมูลการสมัคร",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Itim"),
                ))),
    );
  }

  Widget _buildPetImage(String? petType) {
    String imagePath =
        'Image/pet.png'; // รูปภาพเริ่มต้นสำหรับสัตว์เลี้ยงประเภทอื่น ๆ

    if (petType == 'สุนัข') {
      imagePath = 'Image/dog.png'; // รูปภาพสำหรับสุนัข
    }

    return Image.asset(
      imagePath,
      width: 30, // กำหนดขนาดความกว้างของรูปภาพ
      height: 50, // กำหนดขนาดความสูงของรูปภาพ
      color: Colors.black, // ตั้งค่าสีพื้นหลัง
    );
  }
}
