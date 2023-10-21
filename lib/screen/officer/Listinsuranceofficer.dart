import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pet_insurance/model/Petinsuranceregister.dart';
import 'package:pet_insurance/screen/officer/updateSattus.dart';

import '../../controller/OfficerController.dart';
import 'OfficerAddinsurance.dart';

class ListInsuranceScreen extends StatefulWidget {
  const ListInsuranceScreen({super.key});

  @override
  State<ListInsuranceScreen> createState() => _ListInsuranceScreenState();
}

class _ListInsuranceScreenState extends State<ListInsuranceScreen> {
  final OfficerController officerController = OfficerController();

  List<Petinsuranceregister>? petinsuranceregister;

  bool? isLoade = false;
  void fetcData() async {
    setState(() {
      isLoade = false;
    });
    petinsuranceregister = await officerController.listInsurancereg();
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
              return Addinsurance();
            }));
          },
        ),
      ),
      body: isLoade == true? ListView.builder(
          itemCount: petinsuranceregister?.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Card(
                  elevation: 10,
                  child: ListTile(
                    leading: Text("${petinsuranceregister?[index].member?.fullname}" +
                        "${petinsuranceregister?[index].status}"),
                    onTap: () {
                      print("Click at ${index}");
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => UpdateStatus(
                              insurance_regId: (petinsuranceregister?[index].insurance_regId?? 0), 
                              insurance_planId: (petinsuranceregister?[index].insurancedetail?.insurance_planId.toString()??""),)));
                    },
                  )),
            );
          }) : Container(),
    ));
  }
}
