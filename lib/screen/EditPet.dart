import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pet_insurance/screen/ListPet.dart';
import 'package:pet_insurance/screen/View_insurance.dart';

import '../controller/Insuranceregister.dart';
import '../controller/MemberController.dart';
import '../controller/PetdetailController.dart';
import '../model/Member.dart';

import 'package:http/http.dart' as http;

import '../model/Petdetail.dart';
import 'AddPet.dart';

class EditPet extends StatefulWidget {
  final String pet_id;
  const EditPet({Key? key, required this.pet_id}) : super(key: key);

  @override
  State<EditPet> createState() => _EditPetState();
}

enum Type { Dog, Cat }

enum TypeGender { male, female }

enum TypeSpice { purebred, mixedbreed }

const List<String> listanimal_Spice = <String>['1', '2'];

class _EditPetState extends State<EditPet> {
  String? user;
  bool? isLoaded;
  Member? member;
  Petdetail? petdetail;

  TextEditingController namePetTextController = TextEditingController();
  TextEditingController agePetTextController = TextEditingController();
  TextEditingController genderpetTextController = TextEditingController();
  TextEditingController TypeTextController = TextEditingController();
  TextEditingController speciesController = TextEditingController();
  TextEditingController animal_speciesController = TextEditingController();

  String listanimal = listanimal_Spice.first;
  String listage = listAge.first;

  var type;
  var typeSpice;
  var typegender;

  String? types;
  String? typespices;
  String? species;
  String? typegenders;

  void setData() async {
    namePetTextController.text = petdetail?.namepet??"";
    agePetTextController.text = petdetail?.agepet ?? "";
    genderpetTextController.text = petdetail?.gender ?? "";
    TypeTextController.text = petdetail?.type ?? "";
    speciesController.text = petdetail?.species ?? "";
    animal_speciesController.text = petdetail?.animal_species ?? "";
  }

  void petdata(String petId) async {
    setState(() {
      isLoaded = false;
    });
    var response = await petdetailController.getPetdetailById(petId);
    petdetail = Petdetail.fromJsonToPetdetail(response);
    print(response);
    setData;
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    petdata(widget.pet_id);
    setState(() {
      if (petdetail?.type == "สุนัข") {
        type = "Dog";
      } else {
        type = "Cat";
      }
      if (petdetail?.species == "พันธุ์แท้") {
        typeSpice = "purebred";
      } else {
        typeSpice = "mixedbreed";
      }
      isLoaded = true;
    });
  }

  final PetdetailController petdetailController = PetdetailController();
  final MemberController memberController = MemberController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("แก้ไขข้อมูลสัตว์เลี้ยง"),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return ListPet();
            }));
          },
        ),
      ),
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildappname(),
              // Text(widget.pet_id),
              buildtitle(),
              // buildtypepet(),
              // buildtitlespice(),
              // buildtypespice(),
              // buildanimalspice(),
              buildnamepet(size),
              // buildagepet(size),
              // buildgenderpet(size),
              // buildbuttom(size),
            ],
          ),
        ),
      ),
    ));
  }

  Row buildgenderpet(double size) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
          child: RadioListTile<TypeGender>(
        value: TypeGender.male,
        groupValue: typegender,
        title: Text("ชาย"),
        onChanged: (TypeGender? val) {
          setState(() {
            typegender = TypeGender.male;
            typegenders = "ชาย";
          });
        },
      )),
      Expanded(
          child: RadioListTile<TypeGender>(
        value: TypeGender.female,
        groupValue: typegender,
        title: Text("หญิง"),
        onChanged: (TypeGender? val) {
          setState(() {
            typegender = TypeGender.female;
            typegenders = "หญิง";
          });
        },
      ))
    ]);
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
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                    return Viewinsurance();
                  }));
                },
                child: Text("เพิ่มสัตว์เลี้ยง"))),
      ],
    );
  }

  Row buildanimalspice() {
    return Row(
      children: [
        Expanded(
            child: Center(
                child: Text("สายพันธุ์", style: TextStyle(fontSize: 15)))),
        Expanded(
          child: Center(
            child: Container(
              width: 150,
              child: DropdownButton<String>(
                iconEnabledColor: Colors.cyan,
                dropdownColor: Color.fromARGB(255, 106, 236, 253),
                alignment: Alignment.centerLeft,
                value: listanimal,
                isExpanded: true,
                onChanged: (String? val) {
                  setState(() {
                    listanimal = val!;
                  });
                },
                items: listanimal_Spice
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        )
      ],
    );
  }

  Container buildtitlespice() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Text("พันธุ์สัตว์"),
    );
  }

  Row buildtypespice() {
    return Row(
      children: [
        Expanded(
            child: RadioListTile<String>(
          value: "purebred",
          groupValue: typeSpice,
          title: Text("พันธุ์แท้"),
          onChanged: (String? val) {
            setState(() {
              typeSpice = speciesController.text;
              typespices = "พันธุ์แท้";
            });
          },
        )),
        Expanded(
            child: RadioListTile<String>(
          value: "mixedbreed",
          groupValue: typeSpice,
          title: Text("พันธุ์ผสม"),
          onChanged: (String? val) {
            setState(() {
              typeSpice = speciesController.text;
              typespices = "พันธุ์ผสม";
            });
          },
        ))
      ],
    );
  }

  Container buildtitle() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Text("สัตว์เลี้ยงของท่าน"),
    );
  }

  Row buildtypepet() {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Expanded(
          child: RadioListTile<String>(
        value: "Dog",
        groupValue: type,
        title: Text("สุนัข"),
        onChanged: (String? val) {
          setState(() {
            type = TypeTextController.text;
            types = "สุนัข";
          });
        },
      )),
      Expanded(
          child: RadioListTile<String>(
        value: "Cat",
        groupValue: type,
        title: Text("แมว"),
        onChanged: (String? val) {
          setState(() {
            type = TypeTextController.text;
            types = "แมว";
          });
        },
      ))
    ]);
  }

  Row buildagepet(double size) {
    return Row(
      children: [
        const Expanded(
          child: Center(
            child: Text(
              "อายุ",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              width: 150,
              child: DropdownButton<String>(
                iconEnabledColor: Colors.cyan,
                dropdownColor: Color.fromARGB(255, 106, 236, 253),
                alignment: Alignment.centerLeft,
                borderRadius: BorderRadius.circular(30),
                value: listage,
                isExpanded: true,
                onChanged: (String? val) {
                  setState(() {
                    listage = val!;
                  });
                },
                items: listAge.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row buildappname() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          child: Text(
            "เพิ่มสัตว์เลี้ยงของท่าน",
            style: TextStyle(fontSize: 20),
          ),
        ),
      ],
    );
  }

  Row buildnamepet(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: size * 0.6,
          child: TextFormField(
            controller: namePetTextController,
            decoration: InputDecoration(
              labelText: "ชื่อสัตว์",
              prefixIcon: Icon(Icons.account_circle_outlined),
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
