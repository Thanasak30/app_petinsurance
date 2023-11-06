import 'package:flutter/cupertino.dart';
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

List<String> dogData = [
  'เชาเชา',
  'อิงลิชบูลด็อก',
  'ซาลูกิ',
  'ไจแอนท์ชเนาเซอร์',
  'อัฟกัน',
  'อาคิตะ',
  'ทิเบตันมาสทิฟ'
];

List<String> catData = [
  'อเมริกันช็อตแฮร์',
  'สก็อตติชโฟลด์',
  'มันช์กิ้น',
  'เบงกอล',
  'อเมริกันเคิร์ล',
  'เปอร์เซีย',
  'เมนคูน',
  'แร็กดอลล์ ',
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

  String listage = listAge.first;

  Type? type;
  String? selectedPet;
  var typegender;

  String? listanimal;
  String? types;
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
    selectedPet = dogData.first;
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
          if (response.statusCode == 500) {
            showFailToAddPetAlert();
          } else {
            Navigator.pop(context);
            showUpAddPetSuccessAlert();
          }
        },
        cancelBtnText: "ไม่",
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
        title: const Text("เพิ่มสัตว์เลี้ยง",style: TextStyle(fontFamily: "Itim"),),
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<TypeGender>(
          value: TypeGender.male,
          groupValue: typegender,
          onChanged: (TypeGender? val) {
            setState(() {
              typegender = TypeGender.male;
              typegenders = "ชาย";
            });
          },
        ),
        Text('ชาย',style: TextStyle(fontFamily: "Itim"),),
        SizedBox(width: 20),
        Radio<TypeGender>(
          value: TypeGender.female,
          groupValue: typegender,
          onChanged: (TypeGender? val) {
            setState(() {
              typegender = TypeGender.female;
              typegenders = "หญิง";
            });
          },
        ),
        Text('หญิง',style: TextStyle(fontFamily: "Itim"),),
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
                  Petdetail addPets = Petdetail(
                    member: member,
                    agepet: listage.toString(),
                    gender: typegenders.toString(),
                    namepet: namePetTextController.text,
                    species: selectedPet.toString(),
                    type: types.toString(),
                  );
                  showSureToAddPetAlert(
                      addPets.member!.memberId.toString(),
                      addPets.agepet.toString(),
                      addPets.gender.toString(),
                      addPets.namepet.toString(),
                      addPets.species.toString(),
                      addPets.type.toString());
                },
                child: Text("เพิ่มสัตว์เลี้ยง",style: TextStyle(fontFamily: "Itim"),))),
      ],
    );
  }

  Row buildtypepet() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<Type>(
          value: Type.Dog,
          groupValue: type,
          onChanged: (Type? val) {
            setState(() {
              type = Type.Dog;
              types = "สุนัข";
              selectedPet = null;
            });
          },
        ),
        Text('สุนัข',style: TextStyle(fontFamily: "Itim"),),
        SizedBox(width: 20),
        Radio<Type>(
          value: Type.Cat,
          groupValue: type,
          onChanged: (Type? val) {
            setState(() {
              type = Type.Cat;
              types = "แมว";
              selectedPet = null;
            });
          },
        ),
        Text('แมว',style: TextStyle(fontFamily: "Itim"),),
        SizedBox(width: 20),
        if (type != null)
          DropdownButton<String>(
            hint: Text('เลือกสายพันธุ์',style: TextStyle(fontFamily: "Itim"),),
            value: selectedPet,
            onChanged: (String? newValue) {
              setState(() {
                selectedPet = newValue!;
              });
            },
            items: type == Type.Dog
                ? dogData.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style: TextStyle(fontFamily: "Itim"),),
                    );
                  }).toList()
                : catData.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value,style: TextStyle(fontFamily: "Itim"),),
                    );
                  }).toList(),
          ),
      ],
    );
  }

  Container buildtitle() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Text("สัตว์เลี้ยงของท่าน"),
    );
  }

  Row buildagepet(double size) {
    return Row(
      children: [
        const Expanded(
          child: Center(
            child: Text(
              "อายุ",
              style: TextStyle(fontSize: 15,fontFamily: "Itim"),
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
                }).toList(),style: TextStyle(fontFamily: "Itim",color: Colors.black),
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
            style: TextStyle(fontSize: 20,fontFamily: "Itim"),
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
          style: TextStyle(fontFamily: "Itim"),),
        ),
      ],
    );
  }
}
