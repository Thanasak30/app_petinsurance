import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:pet_insurance/controller/OfficerController.dart';
import 'package:pet_insurance/controller/PaymentController.dart';
import 'package:pet_insurance/model/Insurancedetail.dart';
import 'package:pet_insurance/model/Officer.dart';
import 'package:pet_insurance/screen/View_insurance.dart';
import 'package:pet_insurance/screen/insurance_reg4.dart';

import '../controller/MemberController.dart';
import '../controller/PetdetailController.dart';
import '../model/Member.dart';
import '../model/Payment.dart';
import '../model/Petdetail.dart';
import '../model/Petinsuranceregister.dart';
import 'Payments.dart';

class InsuranceREG5 extends StatefulWidget {
  final String pet_id;
  final int insurance_planId;
  final int insurance_regId;
  const InsuranceREG5({
    Key? key,
    required this.pet_id,
    required this.insurance_planId,
    required this.insurance_regId,
  }) : super(key: key);

  @override
  State<InsuranceREG5> createState() => _InsuranceREG5State();
}

class _InsuranceREG5State extends State<InsuranceREG5> {
  String? user;
  Member? member;
  Petdetail? petdetail;
  bool? isLoaded;
  Officer? officer;
  Payment? payment;
  Insurancedetail? insurancedetail;
  Petinsuranceregister? petinsuranceregister;

  String? substring;

  var dateFormat = DateFormat('dd-MM-yyyy');
  DateTime currentDate = DateTime.now();
  DateTime? birthday;

  final MemberController memberController = MemberController();
  final PetdetailController petdetailController = PetdetailController();
  final OfficerController officerController = OfficerController();
  final PaymentController paymentController = PaymentController();

  void fetcData(String petId, int insurance_planId, int insurance_regId) async {
    user = await SessionManager().get("username");
    print(user);
    member = await memberController.getMemberById(user!);
    print("testusername ${member?.username?.username}");

    var response = await petdetailController.getPetdetailById(petId);
    petdetail = Petdetail.fromJsonToPetdetail(response);
    print(response);
    var responses =
        await officerController.getInsuranceById(insurance_planId.toString());
    insurancedetail = Insurancedetail.fromJsonToInsurancedetail(responses);
    var insurancereg =
        await officerController.getInsuranceregById(insurance_regId);
    petinsuranceregister =
        Petinsuranceregister.fromJsonToPetregister(insurancereg);
    var payments =
        await paymentController.getReferentById(insurance_regId.toString());
    payment = Payment.fromJsonToPayment(payments);
    setState(() {
      substring = insurancedetail?.price
          .toString()
          .substring(0, insurancedetail!.price.toString().indexOf('.'));
      isLoaded = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetcData(widget.pet_id, widget.insurance_planId, widget.insurance_regId);
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
              return Viewinsurance();
            }));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
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
                    Text("ชื่อผู้เอาประกันภัย: ${member?.fullname ?? ''}"),
                    Text(
                        "วัน/เดือน/ปีเกิด: ${dateFormat.format(member?.brithday ?? DateTime.now())}"),
                    Text("เลขบัตรประชาชน: ${member?.idcard ?? ''}"),
                    Text("ที่อยู่ผู้เอาประกัน: ${member?.address ?? ''}"),
                    Text("เบอร์โทรศัพท์: ${member?.mobileno ?? ''}"),
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
                    Text("ชื่อสัตว์เลี้ยง: ${petdetail?.namepet ?? ''}"),
                    Text("อายุ: ${petdetail?.agepet ?? ''}"),
                    Text("สายพันธุ์: ${petdetail?.animal_species ?? ''}"),
                    Text("เพศ: ${petdetail?.gender ?? ''}"),
                  ],
                ),
              ),
            ),
            // ส่วนข้อมูลสัตว์เลี้ยงจบที่นี่

            // เริ่มต้นส่วนข้อมูลกรมธรรม์
            Card(
              child: Visibility(
                visible: payment?.status == "ชำระเงินแล้ว",
                child: Container(
                  padding: EdgeInsets.all(16),
                  color: Colors.grey[300],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "รายละเอียดกรมธรรม์",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                          "แผนประกันภัย: ${insurancedetail?.insurance_name ?? ''}"),
                      Text("ทุนประกันภัย: ${Total()}"),
                      Text(
                          "วันเริ่มต้นคุ้มครอง: ${dateFormat.format(petinsuranceregister?.startdate ?? DateTime.now())}"),
                      Text(
                          "วันสิ้นสุดคุ้มครอง: ${dateFormat.format(petinsuranceregister?.enddate ?? DateTime.now())}"),
                      Text("เลขกรรมธรรม์: ${payment?.reference_number}"),
                    ],
                  ),
                ),
              ),
            ),
            // ส่วนข้อมูลกรมธรรม์จบที่นี่

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

            // ปุ่มไปหน้าชำระเงิน
            Visibility(
              visible: petinsuranceregister?.status == "อนุมัติ",
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 16),
                width: size * 0.6,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (_) => Payments(
                          insurance_regId: widget.insurance_regId,
                          substring: '$substring',
                        ),
                      ),
                    );
                  },
                  child: Text("ไปหน้าชำระเงิน"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
