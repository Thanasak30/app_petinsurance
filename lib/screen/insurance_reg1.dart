import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pet_insurance/controller/PetdetailController.dart';
import 'package:pet_insurance/model/Petdetail.dart';
import 'package:pet_insurance/screen/View_insurance.dart';
import 'package:pet_insurance/screen/insurance_reg4.dart';

import '../controller/MemberController.dart';
import '../model/Insurancedetail.dart';
import '../model/Member.dart';
import 'insurance_reg2.dart';

class InsuranceREG extends StatefulWidget {
  final int insurance_planId;
  const InsuranceREG({super.key, required this.insurance_planId});

  @override
  State<InsuranceREG> createState() => _InsuranceREGState();
}

class _InsuranceREGState extends State<InsuranceREG> {
  final PetdetailController petdetailController = PetdetailController();
  final MemberController memberController = MemberController();

  List<Petdetail>? petdetail;
  Insurancedetail? insurancedetails;
  Member? member;
  String? user;
  String? checkpet;

  bool? isLoade;
  void fetcData() async {
    setState(() {
      isLoade = false;
    });
    user = await SessionManager().get("username");
    print(user);
    member = await memberController.getMemberById(user!);
    petdetail = await petdetailController
        .listShowPetdetailByMember(member!.memberId.toString());
        print(member!.memberId.toString());
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
        title: const Text("เลือกสัตว์เลี้ยงที่ต้องการทำประกัน"),
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
      body: ListView.builder(
          itemCount: petdetail?.length,
          itemBuilder: (context, index) {
            // if(petdetail?[index].status == "รอการอนุมัติ"){
            //   checkpet = petdetail?[index].namepet;
            // }
            // print(checkpet);
            return Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Card(
                  elevation: 10,
                  child: ListTile(
                    leading: Text("${petdetail?[index].namepet}"),
                    onTap: () {
                      print("pet_id ${petdetail?[index].petId}");
                      print("Click at ${index}");
                      print(widget.insurance_planId);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => InsuranceREG4(
                              pet_id: (petdetail?[index].petId).toString(),
                              insurance_planId: widget.insurance_planId.toString())));
                    },
                  )),
            );
          }),
    );
  }
}
