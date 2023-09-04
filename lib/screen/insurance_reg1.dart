import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pet_insurance/controller/PetdetailController.dart';
import 'package:pet_insurance/model/Petdetail.dart';

import 'insurance_reg2.dart';

class InsuranceREG extends StatefulWidget {
  const InsuranceREG({super.key});

  @override
  State<InsuranceREG> createState() => _InsuranceREGState();
}

const List<String> listPet = <String>['1', '2'];

class _InsuranceREGState extends State<InsuranceREG> {
  final PetdetailController petdetailController = PetdetailController();

  List<Petdetail>? petdetail;

  bool? isLoade;
  void fetcData() async {
    setState(() {
      isLoade = false;
    });
    petdetail = await petdetailController.listAllPetdetail();
    setState(() {
      isLoade = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetcData();
  }

  String listpet = listPet.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("เลือกสัตว์เลี้ยงที่ต้องการทำประกัน"),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {},
        ),
      ),
      body: ListView.builder(
          itemCount: petdetail?.length,
          itemBuilder: (context, index) {
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
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) =>
                              InsuranceREG2(pet_id: (petdetail?[index].petId).toString())));
                    },
                  )),
            );
          }),
    );
  }

}
