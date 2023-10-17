import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pet_insurance/screen/ListPet.dart';
import 'package:pet_insurance/screen/View_insurance.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../controller/Insuranceregister.dart';
import '../controller/MemberController.dart';
import '../controller/PetdetailController.dart';
import '../model/Member.dart';

import 'package:http/http.dart' as http;

import '../model/Petdetail.dart';
import 'AddPet.dart';

class EditPet extends StatefulWidget {
  final String pet_id;
  final String member_Id;
  const EditPet({Key? key, required this.pet_id, required this.member_Id})
      : super(key: key);

  @override
  State<EditPet> createState() => _EditPetState();
}

enum Type { Dog, Cat }

enum TypeGender { male, female }

enum TypeSpice { purebred, mixedbreed }

const List<String> listanimal_Spice = <String>[
  'เชาเชา',
  'อิงลิชบูลด็อก',
  'ซาลูกิ',
  'ไจแอนท์ชเนาเซอร์',
  'อัฟกัน',
  'อาคิตะ',
  'ทิเบตัน มาสทิฟ'
];
const List<String> listanimal_Spice_mixedbreed = <String>[
  'ดอร์กี',
  'พิตสกี้',
  'ชูสกี้',
  'ดัลมัชชุนด์',
  'ลาบสกี้',
  'จุง',
  'ฮอร์กี'
];
const List<String> listanimal_Spice_Cat = <String>[
  'อเมริกัน ช็อตแฮร์ ',
  'บริติช ช็อตแฮร์',
  'สก็อตติช โฟลด์ ',
  'มันช์กิ้น',
  'เบงกอล',
  'อเมริกัน เคิร์ล',
  'เปอร์เซีย',
  'เมนคูน'
];

class _EditPetState extends State<EditPet> {
  String? pet;
  bool? isLoaded;
  Member? member;
  Petdetail? petdetail;
  String? user;

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
  // var typegender;

  String? types;
  String? typespices;

  String? typegenders;
  String? species;

  dynamic dropdownanimal;
  dynamic dropdownage;

  TypeGender? typeGender;
  Type? Types;
  TypeSpice? typeSpices;

  

  void setData() async {
    namePetTextController.text = petdetail?.namepet ?? "";
    agePetTextController.text = petdetail?.agepet ?? "";
    genderpetTextController.text = petdetail?.gender ?? "";
    TypeTextController.text = petdetail?.type ?? "";
    speciesController.text = petdetail?.species ?? "";
    animal_speciesController.text = petdetail?.animal_species ?? "";
  }

  void petdata(String petId, String member_Id) async {
    var response = await petdetailController.getPetdetailById(petId);
    petdetail = Petdetail.fromJsonToPetdetail(response);
    print(response);
    print(petdetail?.type);

    user = await SessionManager().get("username");
    print(user);
    member = await memberController.getMemberById(user!);
    print(member?.memberId);

    dropdownanimal = petdetail?.animal_species;
    dropdownage = petdetail?.agepet;
    types = petdetail?.type;
    typegenders = petdetail?.gender;
    typespices = petdetail?.species;

    print("gender" + dropdownanimal);
    switchradio();
    setState(() {
      setData();
      isLoaded = true;
    });
  }

  void switchradio() async {
    Type? convertToType(String? value) {
      switch (value) {
        case 'สุนัข':
          return Type.Dog;
        case 'แมว':
          return Type.Cat;
      }
    }

    String? type = petdetail?.type;
    Types = convertToType(type);
/*-------------------------------------------------- */
    TypeSpice? convertToTypeSpice(String? value) {
      switch (value) {
        case 'พันธุ์แท้':
          return TypeSpice.purebred;
        case 'พันธุ์ผสม':
          return TypeSpice.mixedbreed;
      }
    }

    String? typespices = petdetail?.species;
    typeSpices = convertToTypeSpice(typespices);
/*-------------------------------------------------- */
    TypeGender? convertToTypeGender(String? value) {
      switch (value) {
        case 'ชาย':
          return TypeGender.male;
        case 'หญิง':
          return TypeGender.female;
      }
    }

    String? typegender = petdetail?.gender;
    typeGender = convertToTypeGender(typegender);
  }

  void showSureToUpdateMemberAlert(Petdetail uPetdetail) {
    QuickAlert.show(
        context: context,
        title: "คุณแน่ใจหรือไม่ ? ",
        text: "คุณต้องการอัพเดทข้อมูลสมาชิกหรือไม่ ? ",
        type: QuickAlertType.warning,
        confirmBtnText: "แก้ไข",
        onConfirmBtnTap: () async {
          http.Response response =
              await petdetailController.updatePetdetail(uPetdetail);

          if (response.statusCode == 200) {
            Navigator.pop(context);
            showUpdateMemberSuccessAlert();
          } else {
            showFailToUpdateMemberAlert();
          }
        },
        cancelBtnText: "ยกเลิก",
        showCancelBtn: true);
  }

  void showFailToUpdateMemberAlert() {
    QuickAlert.show(
        context: context,
        title: "เกิดข้อผิดพลาด",
        text: "ไม่สามารถอัพเดทข้อมูลสมาชิกได้",
        type: QuickAlertType.error);
  }

  void showUpdateMemberSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: "สำเร็จ",
        text: "อัพเดทข้อมูลสำเร็จ",
        type: QuickAlertType.success,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ListPet()));
        });
  }

  @override
  void initState() {
    super.initState();
    petdata(widget.pet_id, widget.member_Id);
    setState(() {
      // isLoaded = true;
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
              buildtitle(),
              buildtypepet(),
              buildtitlespice(),
              buildtypespice(),
              buildanimalspice(),
              buildnamepet(size),
              buildagepet(size),
              buildgenderpet(size),
              buildbuttom(size),
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
        groupValue: typeGender,
        title: Text("ชาย"),
        onChanged: (TypeGender? val) {
          setState(() {
            typeGender = val;
            typegenders = "ชาย";
          });
        },
      )),
      Expanded(
          child: RadioListTile<TypeGender>(
        value: TypeGender.female,
        groupValue: typeGender,
        title: Text("หญิง"),
        onChanged: (TypeGender? val) {
          setState(() {
            typeGender = val;
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
                  print("MemberId ${member?.memberId}");
                  Petdetail updatePetdetail = Petdetail(
                      petId: petdetail?.petId,
                      agepet: agePetTextController.text = dropdownage,
                      gender: typegenders,
                      namepet: namePetTextController.text,
                      species: typespices,
                      type: types,
                      member: member,
                      animal_species: animal_speciesController.text =
                          dropdownanimal,);

                  showSureToUpdateMemberAlert(updatePetdetail);
                },
                child: Text("แก้ไขข้อมูลสัตว์เลี้ยง"))),
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
                value: dropdownanimal,
                isExpanded: true,
                onChanged: (String? val) {
                  setState(() {
                    dropdownanimal = val!;
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
            child: RadioListTile<TypeSpice>(
          value: TypeSpice.purebred,
          groupValue: typeSpices,
          title: Text("พันธุ์แท้"),
          onChanged: (TypeSpice? val) {
            setState(() {
              typeSpices = val;
              typespices = "พันธุ์แท้";
            });
          },
        )),
        Expanded(
            child: RadioListTile<TypeSpice>(
          value: TypeSpice.mixedbreed,
          groupValue: typeSpices,
          title: Text("พันธุ์ผสม"),
          onChanged: (TypeSpice? val) {
            setState(() {
              typeSpices = val;
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
        groupValue: Types,
        title: Text("สุนัข"),
        onChanged: (Type? val) {
          setState(() {
            Types = val;
            types = "สุนัข";
          });
        },
      )),
      Expanded(
          child: RadioListTile<Type>(
        value: Type.Cat,
        groupValue: Types,
        title: Text("แมว"),
        onChanged: (Type? val) {
          setState(() {
            Types = val;
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
                value: dropdownage,
                isExpanded: true,
                onChanged: (String? val) {
                  setState(() {
                    dropdownage = val!;
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
