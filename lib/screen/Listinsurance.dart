import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
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
  const ListInsurance({super.key});

  @override
  State<ListInsurance> createState() => _ListInsuranceState();
}

class _ListInsuranceState extends State<ListInsurance> {
  final PetdetailController petdetailController = PetdetailController();
  final MemberController memberController = MemberController();
  final OfficerController officerController = OfficerController();

  List<Insurancedetail>? insurancedetail;
  List<Petinsuranceregister>? petinsuranceregister;

  List<Petdetail>? petdetail;
  Member? member;
  String? user;

  Duration? checkdate;
  int? differancedate;

  bool? isLoade = false;
  void fetcData() async {
    setState(() {
      isLoade = false;
    });
    user = await SessionManager().get("username");
    print(user);
    member = await memberController.getMemberById(user!);
    petdetail = await petdetailController
        .listAllPetdetailByMember(member!.memberId.toString());
    petinsuranceregister =
        await officerController.listInsurance(member!.memberId.toString());

    setState(() {

      isLoade = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetcData();
  }

  @override
  Widget build(BuildContext context) {
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
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      child: Card(
                        elevation: 10,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${petinsuranceregister?[index].petdetail?.namepet}",
                                style: TextStyle(fontFamily: "Itim"),
                              ),
                              Text(
                                "${petinsuranceregister?[index].status}",
                                style: TextStyle(
                                    color:
                                        petinsuranceregister?[index].status !=
                                                'อนุมัติ'
                                            ? Colors.red
                                            : Colors.green,
                                    fontFamily: "Itim"),
                              ),
                            ],
                          ),
                          onTap: () {
                            print(
                                "pet_id ${petinsuranceregister?[index].petdetail?.petId ?? "N/A"}");
                            print("Click at ${index}");
                            print(
                                "insurance_planId ${petinsuranceregister?[index].insurancedetail?.insurance_planId ?? 0}");
                            print(
                                "insurance_regId ${petinsuranceregister?[index].insurance_regId ?? 0}");
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
