import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:pet_insurance/screen/View_insurance.dart';
import 'package:pet_insurance/screen/insurance_reg1.dart';

import '../controller/MemberController.dart';
import '../controller/PetdetailController.dart';
import '../model/Member.dart';
import 'Register.dart';

class AddPet extends StatefulWidget {
  const AddPet({super.key});

  @override
  State<AddPet> createState() => _AddPetState();
}

enum Type { Dog, Cat }

enum TypeSpice { purebred, mixedbreed }

const List<String> listanimal_Spice = <String>['1', '2'];
const List<String> listAge = <String>[
  '8 สัปดาห์ - 1 ปี',
  '2 ปี',
  '3 ปี',
  '4 ปี',
  '5 ปี',
  '6 ปี',
  '7 ปี'
];

class _AddPetState extends State<AddPet> {
  String? user;
  bool? isLoaded;
  Member? member;

  TextEditingController namePetTextController = TextEditingController();
  TextEditingController agePetTextController = TextEditingController();
  TextEditingController genderpetTextController = TextEditingController();

  String listanimal = listanimal_Spice.first;
  String listage = listAge.first;

  var type;
  var typeSpice;

  String? types;
  String? typespices;
  String? species;

  final PetdetailController petdetailController = PetdetailController();
  final MemberController memberController = MemberController();

  void fetcData() async {
    user = await SessionManager().get("username");
    print(user);
    member = await memberController.getMemberById(user!);
    print("testusername ${member?.username?.username}");
    setState(() {
      isLoaded = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetcData();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("เพิ่มสัตว์เลี้ยง"),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildappname(),
            buildnamepet(size),
            buildagepet(size),
            buildgenderpet(size),
            buildtitle(),
            buildtypepet(),
            buildtitlespice(),
            buildtypespice(),
            buildanimalspice(),
            buildbuttom(size),
          ],
        ),
      ),
    );
  }

  Row buildgenderpet(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: size * 0.6,
          child: TextFormField(
            controller: genderpetTextController,
            decoration: InputDecoration(
              labelText: "เพศ",
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
                  http.Response response = await petdetailController.addPet(
                    "-",
                    "flase",
                    listage.toString(),
                    genderpetTextController.text,
                    "-",
                    namePetTextController.text,
                    typespices.toString(),
                    types.toString(),
                    member!.memberId.toString(),
                    listanimal.toString(),
                    "flase",
                  );
                  if (response.statusCode == 500) {
                    print("Error!");
                  } else {
                    print("Member was added successfully!");
                  }
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                    return InsuranceREG();
                  }));
                },
                child: Text("เพิ่มสัตว์เลี้ยง"))),
      ],
    );
  }

  Row buildanimalspice() {
    return Row(
      children: [
        Expanded(child: Text("สายพันธุ์", style: TextStyle(fontSize: 15))),
        Expanded(
          child: DropdownButton<String>(
            value: listanimal,
            isExpanded: true,
            onChanged: (String? val) {
              setState(() {
                listanimal = val!;
              });
            },
            items:
                listanimal_Spice.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
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
            child: RadioListTile<TypeSpice>(
          value: TypeSpice.purebred,
          groupValue: typeSpice,
          title: Text("พันธุ์แท้"),
          onChanged: (TypeSpice? val) {
            setState(() {
              typeSpice = TypeSpice.purebred;
              typespices = "พันธุ์แท้";
            });
          },
        )),
        Expanded(
            child: RadioListTile<TypeSpice>(
          value: TypeSpice.mixedbreed,
          groupValue: typeSpice,
          title: Text("พันธุ์ผสม"),
          onChanged: (TypeSpice? val) {
            setState(() {
              typeSpice = TypeSpice.mixedbreed;
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
          child: RadioListTile<Type>(
        value: Type.Dog,
        groupValue: type,
        title: Text("สุนัข"),
        onChanged: (Type? val) {
          setState(() {
            type = Type.Dog;
            types = "สุนัข";
          });
        },
      )),
      Expanded(
          child: RadioListTile<Type>(
        value: Type.Cat,
        groupValue: type,
        title: Text("แมว"),
        onChanged: (Type? val) {
          setState(() {
            type = Type.Cat;
            types = "แมว";
          });
        },
      ))
    ]);
  }

  Row buildagepet(double size) {
    return Row(
      children: [
        Expanded(child: Text("อายุ", style: TextStyle(fontSize: 15))),
        Expanded(
          child: DropdownButton<String>(
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
                child: Text(value),
              );
            }).toList(),
          ),
        )
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
