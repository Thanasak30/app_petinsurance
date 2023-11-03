import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pet_insurance/controller/OfficerController.dart';
import 'package:pet_insurance/model/Insurancedetail.dart';
import 'package:pet_insurance/screen/officer/ListAllinsurance2.dart';


import 'EditInsurance.dart';
import 'OfficerAddinsurance.dart';

class ListAllinsurance extends StatefulWidget {
  const ListAllinsurance({super.key});

  @override
  State<ListAllinsurance> createState() => _ListAllinsuranceState();
}

class _ListAllinsuranceState extends State<ListAllinsurance> {

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
      appBar: AppBar(
        title: Text("รายการแผนประกัน",style: TextStyle(fontFamily: "Itim"),),
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
      body: ListView.builder(
          itemCount: insurancedetail?.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Card(
                  elevation: 10,
                  child: ListTile(
                    leading: Text("${insurancedetail?[index].insurance_name}",style: TextStyle(fontFamily: "Itim"),),
                    onTap: () {
                      print("insurance_planId ${insurancedetail?[index].insurance_planId}");
                      print("Click at ${index}");
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => EditInsurance(
                              insurance_planId: (insurancedetail?[index].insurance_planId) ?? 0)));
                    },
                  )),
            );
          }),
    );
  }
}
