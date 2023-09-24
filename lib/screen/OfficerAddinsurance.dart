import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:pet_insurance/navbar/navbarofficer.dart';
import 'package:pet_insurance/screen/View_insurance.dart';

import '../controller/OfficerController.dart';
import '../navbar/navbar.dart';
import 'package:http/http.dart' as http;

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

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: NavbarOficer(),
      appBar: AppBar(
        title: const Text("เลือกสัตว์เลี้ยงที่ต้องการทำประกัน"),
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildPlantname(size),
              buildPrice(size),
              buildmedical_expenses(size),
              buildtreatment(size),
              buildcost_of_preventive_vaccination(size),
              buildbuttom(size)
            ],
          ),
        ),
      ),
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
                  http.Response response = await officerController.addPlant(
                    PriceController.text,
                    preventive_vaccinationController.text,
                    "",
                    "",
                    PlantnameController.text,
                    MedicalController.text,
                    TreatmentController.text,
                  );
                  if (response.statusCode == 500) {
                    print("Error!");
                  } else {
                    print(" addplant successfully!");
                  }
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                    return Addinsurance();
                  }));
                },
                child: Text("เพิ่มแผนประกันภัย"))),
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
          ),
        ),
      ],
    );
  }
}
