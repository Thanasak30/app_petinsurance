import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:pet_insurance/model/Petdetail.dart';
import 'package:pet_insurance/screen/View_insurance.dart';
import 'package:pet_insurance/screen/insurance_reg1.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../controller/MemberController.dart';
import '../controller/PetdetailController.dart';
import '../model/Member.dart';
import 'ListPet.dart';
import 'Register.dart';

class AddPet extends StatefulWidget {
  const AddPet({super.key});

  @override
  State<AddPet> createState() => _AddPetState();
}

enum Type { Dog, Cat }

enum TypeGender { male, female }

const List<String> listanimal_Spice_DOG = <String>[
  'เชาเชา',
  'อิงลิชบูลด็อก',
  'ซาลูกิ',
  'ไจแอนท์ชเนาเซอร์',
  'อัฟกัน',
  'อาคิตะ',
  'ทิเบตัน มาสทิฟ'
];

const List<String> listanimal_Spice_Cat = <String>[
  'เชาเชา',
  'อิงลิชบูลด็อก',
  'ซาลูกิ',
  'ไจแอนท์ชเนาเซอร์',
  'อัฟกัน',
  'อาคิตะ',
  'ทิเบตัน มาสทิฟ'
];

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

  String listanimal = listanimal_Spice_DOG.first;
  String listage = listAge.first;

  var type;
  var typeSpice;
  var typegender;

  String? types;
  String? typespices;
  String? species;
  String? typegenders;

  Petdetail? petdetail;

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

  void showSureToAddPetAlert(String memberId, String agepet, String gender,
      String namepet, String species, String type) {
    QuickAlert.show(
        context: context,
        title: "คุณแน่ใจหรือไม่ ? ",
        text: "คุณต้องการเพิ่มสัตว์เลี้ยงหรือไม่ ? ",
        type: QuickAlertType.warning,
        confirmBtnText: "ใช่",
        onConfirmBtnTap: () async {
          http.Response response = await petdetailController.addPet(
            memberId,
            agepet,
            gender,
            namepet,
            species,
            type,
          );

          if (response.statusCode == 200) {
            Navigator.pop(context);
            showUpAddPetSuccessAlert();
          } else {
            showFailToAddPetAlert();
          }
        },
        cancelBtnText: "ยกเลิก",
        showCancelBtn: true);
  }

  void showFailToAddPetAlert() {
    QuickAlert.show(
        context: context,
        title: "เกิดข้อผิดพลาด",
        text: "ไม่สามารถเพิ่มสัตว์เลี้ยงได้",
        type: QuickAlertType.error);
  }

  void showUpAddPetSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: "สำเร็จ",
        text: "เพิ่มสัตว์เลี้ยงสำเร็จ",
        type: QuickAlertType.success,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ListPet()));
        });
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
      body: Form(
        child: SingleChildScrollView(
          child: Column(
            children: [
              buildappname(),
              buildtitle(),
              buildtypepet(),
              buildanimalspice(),
              buildnamepet(size),
              buildagepet(size),
              buildgenderpet(size),
              buildbuttom(size),
            ],
          ),
        ),
      ),
    );
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
                  Petdetail addPets = Petdetail(
                    member: member,
                    agepet: listage.toString(),
                    gender: typegenders.toString(),
                    namepet: namePetTextController.text,
                    species: listanimal.toString(),
                    type: types.toString(),
                  );
                  showSureToAddPetAlert(
                      member!.memberId.toString(),
                      addPets.agepet.toString(),
                      addPets.gender.toString(),
                      addPets.namepet.toString(),
                      addPets.species.toString(),
                      addPets.type.toString());
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
                items: listanimal_Spice_DOG
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
