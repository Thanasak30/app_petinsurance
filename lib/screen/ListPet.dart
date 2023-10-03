import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pet_insurance/screen/EditPet.dart';

import '../controller/PetdetailController.dart';
import '../model/Petdetail.dart';
import 'View_insurance.dart';
import 'insurance_reg2.dart';

class ListPet extends StatefulWidget {
  const ListPet({super.key});

  @override
  State<ListPet> createState() => _ListPetState();
}

class _ListPetState extends State<ListPet> {
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("รายการสัตว์เลี้ยง"),
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
                          builder: (_) => EditPet(
                              pet_id: (petdetail?[index].petId).toString())));
                    },
                  )),
            );
          }),
    ));
  }
}
