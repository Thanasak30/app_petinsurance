import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pet_insurance/model/Petinsuranceregister.dart';
import 'package:pet_insurance/screen/officer/ListAllinsurance2.dart';
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
                  return ListAllinsurance2();
                }),
              );
            },
          ),
        ),
        body: isLoade == true
            ? ListView.builder(
                itemCount: petinsuranceregister?.length,
                itemBuilder: (context, index) {
                  var petName =
                      petinsuranceregister?[index].petdetail?.namepet ?? "";
                  var memberName =
                      petinsuranceregister?[index].member?.fullname ?? "";
                  var status = petinsuranceregister?[index].status ?? "";

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Card(
                      elevation: 10,
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ชื่อสัตว์เลี้ยง: $petName",style: TextStyle(fontFamily: "Itim"),),
                            Text("ชื่อเจ้าของ: $memberName",style: TextStyle(fontFamily: "Itim"),),
                            Text("สถานะ: $status",style: TextStyle(fontFamily: "Itim"),),
                          ],
                        ),
                        onTap: () {
                          print("Click at $index");
                          if (petinsuranceregister != null &&
                              petinsuranceregister?[index] != null &&
                              petinsuranceregister?[index].insurancedetail !=
                                  null) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) => UpdateStatus(
                                  insurance_regId: petinsuranceregister?[index]
                                          .insurance_regId ??
                                      0,
                                  insurance_planId: petinsuranceregister?[index]
                                          .insurancedetail
                                          ?.insurance_planId ??
                                      0,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              )
            : Container(),
      ),
    );
  }
}
