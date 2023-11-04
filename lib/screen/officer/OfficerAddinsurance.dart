import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:pet_insurance/navbar/navbarofficer.dart';
import 'package:pet_insurance/screen/View_insurance.dart';

import '../../controller/OfficerController.dart';
import 'package:http/http.dart' as http;

import 'ListAllinsurance2.dart';

class Addinsurance extends StatefulWidget {
  const Addinsurance({super.key});

  @override
  State<Addinsurance> createState() => _AddinsuranceState();
}

class _AddinsuranceState extends State<Addinsurance> {
  var dateFormat = DateFormat('dd-MM-yyyy');
  DateTime currentDate = DateTime.now();
  DateTime? birthday;
  DateTime nextYearDate = DateTime.now().add(Duration(days: 365 + 1));

  final OfficerController officerController = OfficerController();

  TextEditingController PlantnameController = TextEditingController();
  TextEditingController MedicalController = TextEditingController();
  TextEditingController TreatmentController = TextEditingController();
  TextEditingController preventive_vaccinationController =
      TextEditingController();
  TextEditingController PriceController = TextEditingController();
  TextEditingController accident_or_illness = TextEditingController();
  TextEditingController pet_funeral_costs = TextEditingController();
  TextEditingController pets_attack_outsiders = TextEditingController();
  TextEditingController third_party_property = TextEditingController();
  TextEditingController duration = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: NavbarOficer(),
      appBar: AppBar(
        title: const Text("เพิ่มแผนประกัน",style: TextStyle(fontFamily: "Itim"),),
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
          style: TextStyle(fontFamily: "Itim"),),
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
          style: TextStyle(fontFamily: "Itim"),),
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
          style: TextStyle(fontFamily: "Itim"),),
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
          style: TextStyle(fontFamily: "Itim"),),
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
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('แจ้งเตือน',style: TextStyle(fontFamily: "Itim"),),
                        content: Text('เพิ่มแผนประกันภัยสำเร็จ!',style: TextStyle(fontFamily: "Itim"),),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK',style: TextStyle(fontFamily: "Itim"),),
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // ปิดกล่องข้อความแจ้งเตือน
                            },
                          ),
                        ],
                      );
                    },
                  );
                  http.Response response = await officerController.addPlant(
                    PriceController.text,
                    accident_or_illness.text,
                    preventive_vaccinationController.text,
                    duration.text,
                    PlantnameController.text,
                    MedicalController.text,
                    pet_funeral_costs.text,
                    pets_attack_outsiders.text,
                    third_party_property.text,
                    TreatmentController.text,
                  );
                  if (response.statusCode == 500) {
                    print("Error!");
                  } else {
                    print(" addplant successfully!");
                  }
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                    return ListAllinsurance2();
                  }));
                },
                child: Text("เพิ่มแผนประกันภัย",style: TextStyle(fontFamily: "Itim"),))),
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
          style: TextStyle(fontFamily: "Itim"),),
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
          style: TextStyle(fontFamily: "Itim"),),
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
         style: TextStyle(fontFamily: "Itim"), ),
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
          style: TextStyle(fontFamily: "Itim"),),
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
          style: TextStyle(fontFamily: "Itim"),),
        ),
      ],
    );
  }
}
