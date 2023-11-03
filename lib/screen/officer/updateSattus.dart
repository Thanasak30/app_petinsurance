import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:pet_insurance/model/Insurancedetail.dart';
import 'package:pet_insurance/model/Officer.dart';
import 'package:pet_insurance/screen/Listinsurance.dart';
import 'package:pet_insurance/screen/Payments.dart';
import 'package:pet_insurance/screen/officer/Listinsuranceofficer.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../constant/constant_value.dart';
import '../../controller/OfficerController.dart';
import '../../model/Petinsuranceregister.dart';
import 'package:http/http.dart' as http;

import 'ListAllinsurance2.dart';
import 'OfficerAddinsurance.dart';

class UpdateStatus extends StatefulWidget {
  final int insurance_regId;
  final int insurance_planId;
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
  Petinsuranceregister? petins;
  Insurancedetail? insurancedetail;
  String? username;
  Officer? officer;

  String? substring;

  String? imgCertFileName;
  String? imgCertFileName1;
  String? imgCertFileName2;
  String? filePath;
  String? filePath1;
  String? filePath2;

  var dateFormat = DateFormat('dd-MM-yyyy');
  DateTime currentDate = DateTime.now();

  bool? isLoade;
  void fetcData(int insurance_regId, int insurance_planId) async {
    setState(() {
      isLoade = false;
    });
    var usernameSession = await SessionManager().get("username");
    username = usernameSession.toString();
    print("USERNAME IS ${username}");
    var response = await officerController.getOfficerByUsername(username ?? "");
    print("RESPONSE IS ${response}");
    officer = Officer.fromJsonToOfficer(response);
    var responses = await officerController.getInsuranceById(insurance_planId);
    insurancedetail = Insurancedetail.fromJsonToInsurancedetail(responses);
    var updatestatus =
        await officerController.getInsuranceregById(insurance_regId);
    petinsuranceregister =
        Petinsuranceregister.fromJsonToPetregister(updatestatus);
    String filePath = petinsuranceregister?.ImgPet ?? "";
    String filePath1 = petinsuranceregister?.health_certificate ?? "";
    String filePath2 = petinsuranceregister?.vaccine_documents ?? "";
    print("Image is ${petinsuranceregister?.ImgPet}");

    imgCertFileName =
        filePath.substring(filePath.lastIndexOf('/') + 1, filePath.length);
    imgCertFileName1 =
        filePath1.substring(filePath1.lastIndexOf('/') + 1, filePath1.length);
    imgCertFileName2 =
        filePath2.substring(filePath2.lastIndexOf('/') + 1, filePath2.length);
    print("$imgCertFileName");
    setState(() {
      substring = insurancedetail?.price
          .toString()
          .substring(0, insurancedetail!.price.toString().indexOf('.'));
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
          http.Response response = await officerController
              .updateInsurancereg(office_id, inusrance_regId);

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

  void showfailToUpdateStatsuAlert() {
    QuickAlert.show(
        context: context,
        title: "เกิดข้อผิดพลาด",
        text: "ไม่สามารถทำการไม่อนุมัติได้",
        type: QuickAlertType.error);
  }

  void showupdateStatusSuccessAlert() {
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

  void showsureToUpdateStatusAlert(String office_id, String inusrance_regId) {
    QuickAlert.show(
        context: context,
        title: "คุณแน่ใจหรือไม่ ? ",
        text: "คุณไม่ต้องการอนุมัติแผนประกันภัย ? ",
        type: QuickAlertType.warning,
        confirmBtnText: "ไม่อนุมัติ",
        onConfirmBtnTap: () async {
          http.Response response = await officerController.updateFailInsurancereg(
              office_id, inusrance_regId);

          if (response.statusCode == 200) {
            Navigator.pop(context);
            showupdateStatusSuccessAlert();
          } else {
            showfailToUpdateStatsuAlert();
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

    total +=
        parseAndAddToTotal(insurancedetail?.accident_or_illness_compensation);
    total +=
        parseAndAddToTotal(insurancedetail?.cost_of_preventive_vaccination);
    total += parseAndAddToTotal(insurancedetail?.medical_expenses);
    total += parseAndAddToTotal(insurancedetail?.pet_funeral_costs);
    total += parseAndAddToTotal(insurancedetail?.pets_attack_outsiders);
    total += parseAndAddToTotal(
        insurancedetail?.third_party_property_values_due_to_pets);
    total += parseAndAddToTotal(insurancedetail?.treatment);

    return total;
  }

  int parseAndAddToTotal(String? value) {
    if (value != null && value != "ไม่คุ้มครอง") {
      int parsedValue = int.tryParse(value) ?? 0;
      return parsedValue;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: Text("สรุปความคุ้มครองและชำระเงิน"),
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                return ListInsuranceScreen();
              }));
            },
          ),
        ),
        body: isLoade == true ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(children: [
            // เริ่มต้นส่วนข้อมูลผู้เอาประกัน
            Card(
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.grey[300],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ข้อมูลผู้เอาประกัน",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                        "ชื่อผู้เอาประกันภัย: ${petinsuranceregister?.member?.fullname ?? ''}"),
                    Text(
                        "วัน/เดือน/ปีเกิด: ${dateFormat.format(petinsuranceregister?.member?.brithday ?? DateTime.now())}"),
                    Text(
                        "เลขบัตรประชาชน: ${petinsuranceregister?.member?.idcard ?? ''}"),
                    Text(
                        "ที่อยู่ผู้เอาประกัน: ${petinsuranceregister?.member?.address ?? ''}"),
                    Text(
                        "เบอร์โทรศัพท์: ${petinsuranceregister?.member?.mobileno ?? ''}"),
                  ],
                ),
              ),
            ),
            // ส่วนข้อมูลผู้เอาประกันจบที่นี่

            // เริ่มต้นส่วนข้อมูลสัตว์เลี้ยง
            Card(
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.grey[300],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "รายละเอียดสัตว์เลี้ยง",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                        "ชื่อสัตว์เลี้ยง: ${petinsuranceregister?.petdetail?.namepet ?? ''}"),
                    Text(
                        "อายุ: ${petinsuranceregister?.petdetail?.agepet ?? ''}"),
                    Text(
                        "เพศ: ${petinsuranceregister?.petdetail?.gender ?? ''}"),
                  ],
                ),
              ),
            ),
            // ส่วนข้อมูลสัตว์เลี้ยงจบที่นี่

            // เริ่มต้นส่วนข้อมูลกรมธรรม์
            Card(
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.grey[300],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "รายละเอียดกรมธรรม์",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                        "แผนประกันภัย: ${insurancedetail?.insurance_name ?? ''}"),
                    Text("ทุนประกันภัย: ${Total()}"),
                    Text(
                        "วันเริ่มต้นคุ้มครอง: ${dateFormat.format(petinsuranceregister?.startdate ?? DateTime.now())}"),
                    Text(
                        "วันสิ้นสุดคุ้มครอง: ${dateFormat.format(petinsuranceregister?.enddate ?? DateTime.now())}"),
                    // Text("เลขกรรมธรรม์: ${payment?.reference_number}"),
                  ],
                ),
              ),
            ),
            // ส่วนข้อมูลกรมธรรม์จบที่นี่
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Card(
                  color: Colors.grey[300],
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "รูปภาพ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10),
                        Text("รูปภาพสัตว์เลี้ยง"),
                        SizedBox(height: 10),
                        _buildPetImage(
                          baseURL + '/insuranceregister/' + imgCertFileName!,
                          BoxFit
                              .contain, // หรือตำแหน่งการ fit อื่น ๆ ตามที่คุณต้องการ
                        ),
                        SizedBox(height: 10),
                        Text("รุปภาพใบวัคซีน"),
                        SizedBox(height: 10),
                        _buildPetImage(
                          baseURL + '/insuranceregister/' + imgCertFileName1!,
                          BoxFit
                              .contain, // หรือตำแหน่งการ fit อื่น ๆ ตามที่คุณต้องการ
                        ),
                        SizedBox(height: 10),
                        Text("รุปภาพใบตรวจสุขภาพ"),
                        SizedBox(height: 10),
                        _buildPetImage(
                          baseURL + '/insuranceregister/' + imgCertFileName2!,
                          BoxFit
                              .contain, // หรือตำแหน่งการ fit อื่น ๆ ตามที่คุณต้องการ
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // ส่วนรูปภาพจบที่นี่

            // ราคาเบี้ยประกันรวม
            Card(
              child: Container(
                padding: EdgeInsets.all(16),
                color: Colors.blue,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ราคาเบี้ยประกันรวม",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "$substring",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            // ส่วนของราคาเบี้ยประกันรวมจบที่นี่

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    width: size * 0.4,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        onPressed: () async {
                          Petinsuranceregister updatePetdetails =
                              Petinsuranceregister(
                            insurance_regId: widget.insurance_regId,
                            officer: officer,
                          );
                          showsureToUpdateStatusAlert(
                              officer?.OfficerId ?? "",
                              petinsuranceregister?.insurance_regId
                                      .toString() ??
                                  "");
                        },
                        child: Text("ไม่อนุมัติการสมัคร"))),
                Container(
                    margin: EdgeInsets.symmetric(vertical: 16),
                    width: size * 0.4,
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
                              petinsuranceregister?.insurance_regId
                                      .toString() ??
                                  "");
                        },
                        child: Text("อนุมัติการสมัคร"))),
              ],
            )
          ]),
        ):Container());
  }

  Widget _buildPetImage(String imageUrl, BoxFit fit) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover, // หรือเลือก fit ตามที่ต้องการ
      width: 100, // กำหนดความกว้างของรูปภาพที่คุณต้องการ
      height: 100, // กำหนดความสูงของรูปภาพที่คุณต้องการ
    );
  }
}
