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
  String selectedStatus = 'ทั้งหมด';

  List<Petinsuranceregister> filterPetInsuranceRegisterByStatus(String status) {
    if (status == 'ทั้งหมด') {
      return petinsuranceregister ?? [];
    } else {
      return (petinsuranceregister ?? []).where((item) => item.status == status).toList();
    }
  }
  void fetcData() async {
    setState(() {
      isLoade = false;
    });
    petinsuranceregister = await officerController.getlistInsurancereg();
    // petinsuranceregister = await officerController.listInsuranceapprove();
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
          title: Text(
            "รายการที่ทำประกัน",
            style: TextStyle(fontFamily: "Itim"),
          ),
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
          actions: [
            // DropdownButton ใน AppBar สำหรับกรองรายการตามสถานะ
            DropdownButton<String>(
              value: selectedStatus,
              onChanged: (String? newValue) {
                setState(() {
                  selectedStatus = newValue ?? 'ทั้งหมด';
                });
              },
              items: ['ทั้งหมด', 'อนุมัติ', 'รอดำเนินการ', 'ไม่อนุมัติ' , 'หมดอายุ']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: TextStyle(fontFamily: 'Itim')),
                );
              }).toList(),
            ),
          ],
        ),
        body: isLoade == true
          ? ListView.builder(
              itemCount: filterPetInsuranceRegisterByStatus(selectedStatus).length,
              itemBuilder: (context, index) {
                var petName =
                    filterPetInsuranceRegisterByStatus(selectedStatus)[index].petdetail?.namepet ?? "";
                var memberName =
                    filterPetInsuranceRegisterByStatus(selectedStatus)[index].member?.fullname ?? "";
                var status = filterPetInsuranceRegisterByStatus(selectedStatus)[index].status ?? "";

                Color getStatusColor(String status) {
                  switch (status) {
                    case 'อนุมัติ':
                      return Colors.green;
                    case 'รอดำเนินการ':
                      return Colors.blueGrey;
                    case 'ไม่อนุมัติ':
                      return Colors.red;
                    default:
                      return Colors.red; // สีเริ่มต้นถ้าไม่ตรงกับเงื่อนไขใด ๆ
                  }
                }

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
                            "ชื่อสัตว์เลี้ยง: $petName",
                            style: TextStyle(fontFamily: "Itim"),
                          ),
                          Text(
                            "ชื่อเจ้าของ: $memberName",
                            style: TextStyle(fontFamily: "Itim"),
                          ),
                          Text(
                            "สถานะ: $status",
                            style: TextStyle(
                              fontFamily: "Itim",
                              color: getStatusColor(status),
                            ),
                          ),
                        ],
                      ),
                      onTap: () {
                        print("Click at $index");
                        if (petinsuranceregister != null &&
                            petinsuranceregister?[index] != null &&
                            petinsuranceregister?[index].insurancedetail != null) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (_) => UpdateStatus(
                                insurance_regId:
                                    filterPetInsuranceRegisterByStatus(selectedStatus)[index].insurance_regId ?? 0,
                                insurance_planId:
                                    filterPetInsuranceRegisterByStatus(selectedStatus)[index].insurancedetail?.insurance_planId ?? 0,
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
          : Center(
              child: CircularProgressIndicator(),
            ),
    ),
  );
}

  // Widget buildCard(String petName, String memberName, String status, int index,
  //     BuildContext context) {
  //   return Card(
  //     elevation: 10,
  //     child: ListTile(
  //       contentPadding: EdgeInsets.all(10),
  //       title: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text("ชื่อสัตว์เลี้ยง: $petName",
  //               style: TextStyle(fontFamily: "Itim")),
  //           Text("ชื่อเจ้าของ: $memberName",
  //               style: TextStyle(fontFamily: "Itim")),
  //           Text("สถานะ: $status", style: TextStyle(fontFamily: "Itim")),
  //         ],
  //       ),
  //       onTap: () {
  //         print("Click at $index");
  //         if (petinsuranceregister != null &&
  //             petinsuranceregister?[index] != null &&
  //             petinsuranceregister?[index].insurancedetail != null) {
  //           Navigator.of(context).pushReplacement(
  //             MaterialPageRoute(
  //               builder: (_) => UpdateStatus(
  //                 insurance_regId:
  //                     petinsuranceregister?[index].insurance_regId ?? 0,
  //                 insurance_planId: petinsuranceregister?[index]
  //                         .insurancedetail
  //                         ?.insurance_planId ??
  //                     0,
  //               ),
  //             ),
  //           );
  //         }
  //       },
  //     ),
  //   );
  // }
}
