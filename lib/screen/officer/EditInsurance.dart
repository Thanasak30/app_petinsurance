import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pet_insurance/controller/OfficerController.dart';
import 'package:pet_insurance/model/Insurancedetail.dart';
import 'package:pet_insurance/model/Officer.dart';
import 'package:pet_insurance/screen/officer/ListAllinsurance.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:http/http.dart' as http;

import 'ListAllinsurance2.dart';
import 'OfficerAddinsurance.dart';

class EditInsurance extends StatefulWidget {
  final int insurance_planId;
  const EditInsurance({Key? key, required this.insurance_planId});

  @override
  State<EditInsurance> createState() => _EditInsuranceState();
}

class _EditInsuranceState extends State<EditInsurance> {
  TextEditingController PlantnameController = TextEditingController();
  TextEditingController MedicalController = TextEditingController();
  TextEditingController TreatmentController = TextEditingController();
  TextEditingController preventive_vaccinationController =
      TextEditingController();
  TextEditingController accident_or_illness = TextEditingController();
  TextEditingController pet_funeral_costs = TextEditingController();
  TextEditingController pets_attack_outsiders = TextEditingController();
  TextEditingController third_party_property = TextEditingController();
  TextEditingController duration = TextEditingController();
  TextEditingController PriceController = TextEditingController();
  OfficerController officerController = OfficerController();

  Insurancedetail? insurancedetail;
  bool? isLoade;
  String? substring;

  void setData() async {
    PlantnameController.text = insurancedetail?.insurance_name ?? "";
    MedicalController.text = insurancedetail?.medical_expenses ?? "";
    TreatmentController.text = insurancedetail?.treatment ?? "";
    preventive_vaccinationController.text =
        insurancedetail?.cost_of_preventive_vaccination ?? "";
    PriceController.text = insurancedetail?.price
            .toString()
            .substring(0, insurancedetail?.price.toString().indexOf('.')) ??
        "";
    accident_or_illness.text =
        insurancedetail?.accident_or_illness_compensation ?? "";
    pet_funeral_costs.text = insurancedetail?.pet_funeral_costs ?? "";
    pets_attack_outsiders.text = insurancedetail?.pets_attack_outsiders ?? "";
    third_party_property.text =
        insurancedetail?.third_party_property_values_due_to_pets ?? "";
    duration.text = insurancedetail?.duration ?? "";
  }

  void fetcData(int insurance_planId) async {
    print(insurance_planId);
    var response = await officerController.getInsuranceById(insurance_planId);
    insurancedetail = Insurancedetail.fromJsonToInsurancedetail(response);
    setState(() {
      setData();
      print(response);
    });
    setState(
      () {
        isLoade = true;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetcData(widget.insurance_planId);
  }

  void showSureToUpdateInsuranceeAlert(Insurancedetail uMember) {
    QuickAlert.show(
        context: context,
        title: "คุณแน่ใจหรือไม่ ? ",
        text: "คุณต้องการอัพเดทข้อมูลสมาชิกหรือไม่ ? ",
        type: QuickAlertType.warning,
        confirmBtnText: "แก้ไข",
        onConfirmBtnTap: () async {
          http.Response response =
              await officerController.updateInsurancedetail(uMember);
          print(response.statusCode);
          if (response.statusCode == 200) {
            Navigator.pop(context);
            showUpdateInsuranctdetailSuccessAlert();
          } else {
            showFailToUpdateInsuranctdetailAlert();
          }
        },
        cancelBtnText: "ยกเลิก",
        showCancelBtn: true);
  }

  void showFailToUpdateInsuranctdetailAlert() {
    QuickAlert.show(
        context: context,
        title: "เกิดข้อผิดพลาด",
        text: "ไม่สามารถอัพเดทข้อมูลสมาชิกได้",
        type: QuickAlertType.error);
  }

  void showUpdateInsuranctdetailSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: "สำเร็จ",
        text: "อัพเดทข้อมูลสำเร็จ",
        type: QuickAlertType.success,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => EditInsurance(
                    insurance_planId: insurancedetail!.insurance_planId ?? 0,
                  )));
        });
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("แก้ไขแผนประกันภัย"),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return ListAllinsurance2();
            }));
          },
        ),
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildPlantname(size),
              buildPrice(size),
              buildduration(size),
              buildmedical_expenses(size),
              buildtreatment(size),
              buildcost_of_preventive_vaccination(size),
              buildaccident_or_illness(size),
              buildpet_funeral_costs(size),
              buildpets_attack_outsiders(size),
              buildthird_party_property(size),
              buildbuttom(size)
            ],
          ),
        ),
      ),
    );
  }

  Row buildduration(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: duration,
            decoration: InputDecoration(
              labelText: "ระยะเวลาของแผนประกัน",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            style: TextStyle(fontFamily: "Itim"),
          ),
        ),
      ],
    );
  }

  Row buildthird_party_property(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: third_party_property,
            decoration: InputDecoration(
              labelText: "สัตว์เลี้ยงโจมตีบุคคลภายนอก ",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            style: TextStyle(fontFamily: "Itim"),
          ),
        ),
      ],
    );
  }

  Row buildpets_attack_outsiders(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: pets_attack_outsiders,
            decoration: InputDecoration(
              labelText: "ทรัพย์สินของบุคคลที่สามอันเนื่องมาจากสัตว์เลี้ยง",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
      ],
    );
  }

  Row buildpet_funeral_costs(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: pet_funeral_costs,
            decoration: InputDecoration(
              labelText: "ค่าจัดงานศพสัตว์เลี้ยง ",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            style: TextStyle(fontFamily: "Itim"),
          ),
        ),
      ],
    );
  }

  Row buildaccident_or_illness(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: accident_or_illness,
            decoration: InputDecoration(
              labelText: "ค่าชดเชยอุบัติเหตุหรือเจ็บป่วย",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            style: TextStyle(fontFamily: "Itim"),
          ),
        ),
      ],
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
                        borderRadius: BorderRadius.circular(30))),
                onPressed: () async {
                  Insurancedetail updateInsurancedetail = Insurancedetail(
                      insurance_planId: insurancedetail?.insurance_planId,
                      price: double.parse(PriceController.text),
                      cost_of_preventive_vaccination:
                          preventive_vaccinationController.text,
                      insurance_name: PlantnameController.text,
                      medical_expenses: MedicalController.text,
                      treatment: TreatmentController.text,
                      duration: insurancedetail?.duration,
                      pet_funeral_costs: pet_funeral_costs.text,
                      pets_attack_outsiders: pets_attack_outsiders.text,
                      third_party_property_values_due_to_pets:
                          third_party_property.text);
                  // print(updateMember?.username?.username);
                  showSureToUpdateInsuranceeAlert(updateInsurancedetail);
                },
                child: Text("แก้ไขแผนประกันภัย"))),
      ],
    );
  }

  Row buildPlantname(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: PlantnameController,
            decoration: InputDecoration(
              labelText: "ชื่อแผนประกัน",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            style: TextStyle(fontFamily: "Itim"),
          ),
        ),
      ],
    );
  }

  Row buildmedical_expenses(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: MedicalController,
            decoration: InputDecoration(
              labelText: "ค่ารักษา",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            style: TextStyle(fontFamily: "Itim"),
          ),
        ),
      ],
    );
  }

  Row buildtreatment(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: TreatmentController,
            decoration: InputDecoration(
              labelText: "การรักษา",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            style: TextStyle(fontFamily: "Itim"),
          ),
        ),
      ],
    );
  }

  Row buildcost_of_preventive_vaccination(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: preventive_vaccinationController,
            decoration: InputDecoration(
              labelText: "การฉีดวัคซีน",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            style: TextStyle(fontFamily: "Itim"),
          ),
        ),
      ],
    );
  }

  Row buildPrice(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: PriceController,
            decoration: InputDecoration(
              labelText: "ราคาแผน",
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
            style: TextStyle(fontFamily: "Itim"),
          ),
        ),
      ],
    );
  }
}
