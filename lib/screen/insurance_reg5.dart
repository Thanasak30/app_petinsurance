import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:intl/intl.dart';
import 'package:pet_insurance/controller/OfficerController.dart';
import 'package:pet_insurance/model/Insurancedetail.dart';
import 'package:pet_insurance/model/Officer.dart';
import 'package:pet_insurance/screen/Payment.dart';
import 'package:pet_insurance/screen/View_insurance.dart';
import 'package:pet_insurance/screen/insurance_reg4.dart';

import '../controller/MemberController.dart';
import '../controller/PetdetailController.dart';
import '../model/Member.dart';
import '../model/Petdetail.dart';
import '../model/Petinsuranceregister.dart';

class InsuranceREG5 extends StatefulWidget {
  final String pet_id;
  final String insurance_planId;
  final int insurance_regId;
  const InsuranceREG5(
      {Key? key,
      required this.pet_id,
      required this.insurance_planId,
      required this.insurance_regId})
      : super(key: key);

  @override
  State<InsuranceREG5> createState() => _InsuranceREG5State();
}

class _InsuranceREG5State extends State<InsuranceREG5> {
  String? user;
  Member? member;
  Petdetail? petdetail;
  bool? isLoaded;
  Officer? officer;
  Insurancedetail? insurancedetail;
  Petinsuranceregister? petinsuranceregister;

  var dateFormat = DateFormat('dd-MM-yyyy');
  DateTime currentDate = DateTime.now();
  DateTime? birthday;

  final MemberController memberController = MemberController();
  final PetdetailController petdetailController = PetdetailController();
  final OfficerController officerController = OfficerController();

  void fetcData(
      String petId, String insurance_planId, int insurance_regId) async {
    user = await SessionManager().get("username");
    print(user);
    member = await memberController.getMemberById(user!);
    print("testusername ${member?.username?.username}");

    var response = await petdetailController.getPetdetailById(petId);
    petdetail = Petdetail.fromJsonToPetdetail(response);
    print(response);
    var responses = await officerController.getInsuranceById(insurance_planId);
    insurancedetail = Insurancedetail.fromJsonToInsurancedetail(responses);
    var insurancereg =
        await officerController.getInsuranceregById(insurance_regId);
    petinsuranceregister =
        Petinsuranceregister.fromJsonToPetregister(insurancereg);
    setState(() {
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
    if (insurancedetail?.accident_or_illness_compensation != null) {
      total += int.parse(
          insurancedetail!.accident_or_illness_compensation.toString());
    }
    if (insurancedetail?.cost_of_preventive_vaccination != null) {
      total +=
          int.parse(insurancedetail!.cost_of_preventive_vaccination.toString());
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
      body: Form(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "ข้อมูลผู้เอาประกัน",
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("ชื่อผู้เอาประกันภัย"),
                Text("${member?.fullname}")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("วัน/เดือน/ปีเกิด"),
                Text("${dateFormat.format(member?.brithday ?? DateTime.now())}")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text("เลขบัตรประชาชน"), Text("${member?.idcard}")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("ที่อยู่ผู้เอาประกัน"),
                Text("${member?.address}")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text("เบอร์โทรศัพท์"), Text("${member?.mobileno}")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("ที่อยู่จัดส่งใบเสร็จ"),
                Text("${member?.member_email}")
              ],
            ),
            Divider(),
            Text(
              "อีเมลสำหรับจัดส่งเอกสาร",
              style: TextStyle(fontSize: 20),
            ),
            Text("${member?.member_email}"),
            Divider(),
            Text(
              "รายละเอียดสัตว์เลี้ยง",
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("ชื่อสัตว์เลี้ยง"),
                Text("${petdetail?.namepet}")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("สายพันธุ์"),
                Text("${petdetail?.animal_species}")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text("พันธุ์สัตว์"), Text("${petdetail?.species}")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text("อายุ"), Text("${petdetail?.agepet}")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text("เพศ"), Text("${petdetail?.gender}")],
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
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (_) => Payment(
                                        insurance_regId: widget.insurance_regId,
                                      )));
                        },
                        child: Text("ไปหน้าชำระเงิน"))),
              ],
            )
          ],
        ),
      )),
    );
  }
}
