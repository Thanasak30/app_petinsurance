import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pet_insurance/controller/OfficerController.dart';
import 'package:pet_insurance/model/Insurancedetail.dart';

import '../../navbar/navbarofficer.dart';
import 'EditInsurance.dart';
import 'OfficerAddinsurance.dart';

class ListAllinsurance2 extends StatefulWidget {
  const ListAllinsurance2({super.key});

  @override
  State<ListAllinsurance2> createState() => _ListAllinsurance2State();
}

class _ListAllinsurance2State extends State<ListAllinsurance2> {
  final OfficerController officerController = OfficerController();

  List<Insurancedetail>? insurancedetail;

  bool? isLoade;
  void fetcData() async {
    setState(() {
      isLoade = false;
    });
    insurancedetail = await officerController.listAllInsurance();
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
    return Scaffold(
      drawer: NavbarOficer(),
      appBar: AppBar(
        title: Text(
          "รายการแผนประกัน",
          style: TextStyle(fontFamily: "Itim"),
        ),
      ),
      body: ListView.builder(
          itemCount: insurancedetail?.length,
          itemBuilder: (context, index) {
            var insurancename = insurancedetail?[index].insurance_name ?? "";
            var price = insurancedetail?[index].price ?? "";
            var medical =
                insurancedetail?[index].medical_expenses;
            var pets_attack = insurancedetail?[index].pets_attack_outsiders;
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
                          "ชื่อแผนประกัน: $insurancename",
                          style: TextStyle(fontFamily: "Itim"),
                        ),
                        Text(
                          "ราคา: $price",
                          style: TextStyle(fontFamily: "Itim"),
                        ),
                        Text(
                          "ค่ารักษาพยาบาล: $medical",
                          style: TextStyle(fontFamily: "Itim"),
                        ),
                        Text(
                          "ค่าคุมครองสัตว์เลี้ยงทำร้ายบุคคลภายนอก: $pets_attack",
                          style: TextStyle(fontFamily: "Itim"),
                        ),
                      ],
                    ),
                    onTap: () {
                      print(
                          "insurance_planId ${insurancedetail?[index].insurance_planId}");
                      print("Click at ${index}");
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => EditInsurance(
                              insurance_planId:
                                  (insurancedetail?[index].insurance_planId) ??
                                      0)));
                    },
                  )),
            );
          }),
    );
  }
}
