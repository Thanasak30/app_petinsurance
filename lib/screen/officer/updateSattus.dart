import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:pet_insurance/model/Insurancedetail.dart';
import 'package:pet_insurance/model/Officer.dart';
import 'package:pet_insurance/screen/Listinsurance.dart';
import 'package:pet_insurance/screen/officer/Listinsuranceofficer.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../controller/OfficerController.dart';
import '../../model/Petinsuranceregister.dart';
import 'package:http/http.dart' as http;

import 'OfficerAddinsurance.dart';

class UpdateStatus extends StatefulWidget {
  final int insurance_regId;
  final String insurance_planId;
  const UpdateStatus(
      {super.key,
      required this.insurance_regId,
      required this.insurance_planId});

  @override
  State<UpdateStatus> createState() => _UpdateStatusState();
}

class _UpdateStatusState extends State<UpdateStatus> {
  final OfficerController officerController = OfficerController();

  Petinsuranceregister? petinsuranceregister;
  Insurancedetail? insurancedetail;
  String? username;
  Officer? officer;

  var dateFormat = DateFormat('dd-MM-yyyy');
  DateTime currentDate = DateTime.now();

  bool? isLoade;
  void fetcData(int insurance_regId, String insurance_planId) async {
    setState(() {
      isLoade = false;
    });
    var usernameSession = await SessionManager().get("username");
    username = usernameSession.toString();
    print("USERNAME IS ${username}");
    var response = await officerController.getOfficerByUsername(username ?? "");
    print("RESPONSE IS ${response}");
    officer = Officer.fromJsonToOfficer(response);
    print("OFFICER IS ${officer}");
    print("OFFICER ID IS : ${officer?.OfficerId}");
    print("OFFICER NAME IS : ${officer?.officername}");

    var responses = await officerController.getInsuranceById(insurance_planId);
    insurancedetail = Insurancedetail.fromJsonToInsurancedetail(responses);
    var updatestatus =
        await officerController.getInsuranceregById(insurance_regId);
    petinsuranceregister =
        Petinsuranceregister.fromJsonToPetregister(updatestatus);
    setState(() {
      isLoade = true;
    });
  }

  void showFailToUpdateStatsuAlert() {
    QuickAlert.show(
        context: context,
        title: "เกิดข้อผิดพลาด",
        text: "ไม่สามารถอนุมัติได้ได้",
        type: QuickAlertType.error);
  }

  void showUpdateStatusSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: "สำเร็จ",
        text: "อัพเดทข้อมูลสำเร็จ",
        type: QuickAlertType.success,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const ListInsuranceScreen()));
        });
  }

  void showSureToUpdateStatusAlert(String office_id, String inusrance_regId) {
    QuickAlert.show(
        context: context,
        title: "คุณแน่ใจหรือไม่ ? ",
        text: "คุณต้องการอนุมัติแผนประกันภัย ? ",
        type: QuickAlertType.warning,
        confirmBtnText: "อนุมัติ",
        onConfirmBtnTap: () async {
          http.Response response = await officerController.updateInsurancereg(
              office_id, inusrance_regId);

          if (response.statusCode == 200) {
            Navigator.pop(context);
            showUpdateStatusSuccessAlert();
          } else {
            showFailToUpdateStatsuAlert();
          }
        },
        cancelBtnText: "ยกเลิก",
        showCancelBtn: true);
  }

  @override
  void initState() {
    super.initState();
    fetcData(widget.insurance_regId, widget.insurance_planId);
  }

  int Total() {
    int total = 0;
    if (insurancedetail?.accident_or_illness_compensation != null &&
        insurancedetail!.accident_or_illness_compensation is num) {
      total +=
          (insurancedetail!.accident_or_illness_compensation as num).toInt();
    }
    if (insurancedetail?.cost_of_preventive_vaccination == "ไม่คุ้มครอง") {
      total += 0;
    }else{
      total += int.parse(insurancedetail?.cost_of_preventive_vaccination.toString() ?? "");
    }
    if (insurancedetail?.medical_expenses != null) {
      total += int.parse(insurancedetail!.medical_expenses.toString());
    }
    if (insurancedetail?.pet_funeral_costs != null) {
      total += int.parse(insurancedetail!.pet_funeral_costs.toString());
    }
    if (insurancedetail?.pets_attack_outsiders != null) {
      total += int.parse(insurancedetail!.pets_attack_outsiders.toString());
    }
    if (insurancedetail?.third_party_property_values_due_to_pets != null) {
      total += int.parse(
          insurancedetail!.third_party_property_values_due_to_pets.toString());
    }
    if (insurancedetail?.treatment != null) {
      total += int.parse(insurancedetail!.treatment.toString());
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("รายการที่ทำประกัน"),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return Addinsurance();
            }));
          },
        ),
      ),
      body: Form(
          child: SingleChildScrollView(
        child: Column(children: [
          Text(
            "ข้อมูลผู้เอาประกัน",
            style: TextStyle(fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("ชื่อผู้เอาประกันภัย"),
              Text("${petinsuranceregister?.member?.fullname}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("วัน/เดือน/ปีเกิด"),
              Text(
                  "${dateFormat.format(petinsuranceregister?.member?.brithday ?? DateTime.now())}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("เลขบัตรประชาชน"),
              Text("${petinsuranceregister?.member?.idcard}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("ที่อยู่ผู้เอาประกัน"),
              Text("${petinsuranceregister?.member?.address}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("เบอร์โทรศัพท์"),
              Text("${petinsuranceregister?.member?.mobileno}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("ที่อยู่จัดส่งใบเสร็จ"),
              Text("${petinsuranceregister?.member?.member_email}")
            ],
          ),
          Divider(),
          Text(
            "อีเมลสำหรับจัดส่งเอกสาร",
            style: TextStyle(fontSize: 20),
          ),
          Text("${petinsuranceregister?.member?.member_email}"),
          Divider(),
          Text(
            "รายละเอียดสัตว์เลี้ยง",
            style: TextStyle(fontSize: 20),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("ชื่อสัตว์เลี้ยง"),
              Text("${petinsuranceregister?.petdetail?.agepet}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("สายพันธุ์"),
              Text("${petinsuranceregister?.petdetail?.animal_species}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("พันธุ์สัตว์"),
              Text("${petinsuranceregister?.petdetail?.species}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("อายุ"),
              Text("${petinsuranceregister?.petdetail?.agepet}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("เพศ"),
              Text("${petinsuranceregister?.petdetail?.gender}")
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("รายละเอียดกรมธรรม์", style: TextStyle(fontSize: 20))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("แผนประกันภัย"),
              Text("${insurancedetail?.insurance_name}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [Text("ทุนประกันภัย"), Text("${Total()}")],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("วันเริ่มต้นคุ้มครอง"),
              Text(
                  "${dateFormat.format(petinsuranceregister?.startdate ?? DateTime.now())}")
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text("วันสิ้นสุดคุ้มครอง"),
              Text(
                  "${dateFormat.format(petinsuranceregister?.enddate ?? DateTime.now())}")
            ],
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("ราคาเบี้ยประกันรวม", style: TextStyle(fontSize: 20)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("${petinsuranceregister?.insurancedetail!.price}",
                  style: TextStyle(fontSize: 20)),
            ],
          ),
          Row(
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
                        Petinsuranceregister updatePetdetail =
                            Petinsuranceregister(
                          insurance_regId: widget.insurance_regId,
                          officer: officer,
                        );
                        showSureToUpdateStatusAlert(
                            officer?.OfficerId ?? "",
                            petinsuranceregister?.insurance_regId.toString() ??
                                "");
                      },
                      child: Text("อนุมัติการสมัคร"))),
            ],
          )
        ]),
      )),
    ));
  }
}
