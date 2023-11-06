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

List<String> dogData = [
  'กรุณาเลือกสายพันธุ์',
  'เชาเชา',
  'อิงลิชบูลด็อก',
  'ซาลูกิ',
  'ไจแอนท์ชเนาเซอร์',
  'อัฟกัน',
  'อาคิตะ',
  'ทิเบตันมาสทิฟ'
];

List<String> catData = [
  'กรุณาเลือกสายพันธุ์',
  'อเมริกันช็อตแฮร์',
  'สก็อตติชโฟลด์',
  'มันช์กิ้น',
  'เบงกอล',
  'อเมริกันเคิร์ล',
  'เปอร์เซีย',
  'เมนคูน',
  'แร็กดอลล์ ',
];

class _EditPetState extends State<EditPet> {
  String? pet;
  bool? isLoaded = false;
  Member? member;
  Petdetail? petdetail;
  List<Petdetail>? petdetails;

  String? user;

  TextEditingController namePetTextController = TextEditingController();
  TextEditingController agePetTextController = TextEditingController();
  TextEditingController genderpetTextController = TextEditingController();
  TextEditingController TypeTextController = TextEditingController();
  TextEditingController speciesController = TextEditingController();
  TextEditingController animal_speciesController = TextEditingController();

  String listage = listAge.first;

  var type;
  var typeSpice;
  // var typegender;

  String? types;
  String? typespices;

  String? selectedPet = 'กรุณาเลือกสายพันธุ์';

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
  }

  void petdata(String petId, String member_Id) async {
    var response = await petdetailController.getPetdetailById(petId);
    petdetail = Petdetail.fromJsonToPetdetail(response);
    // petdetails = await petdetailController.listAllPetdetailByMember(member!.memberId.toString());
    print(response);
    print(petdetail?.type);

    user = await SessionManager().get("username");
    print(user);
    member = await memberController.getMemberById(user!);
    if (member != null) {
      member?.memberId ==
          user!; // ให้ memberId เป็นค่าของ user ที่คุณได้จาก SessionManager
    }
    print(member?.memberId);

    dropdownage = petdetail?.agepet;
    if (petdetail?.type != null) {
      types = petdetail?.type;
    }
    typegenders = petdetail?.gender;

    print("${types}");
    // print("gender" + dropdownanimal);
    switchradio(types ?? "");
    setState(() {
      selectedPet = petdetail?.species ?? "";
      print("Spice $selectedPet");
      setData();
      isLoaded = true;
    });
  }

  void switchradio(String types) async {
    Type? convertToType(types) {
      switch (types) {
        case 'สุนัข':
          return Type.Dog;
        case 'แมว':
          return Type.Cat;
      }
    }

    String? type = petdetail?.type;
    Types = convertToType(type);
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
    print("Member ${uPetdetail.member?.memberId}");
    QuickAlert.show(
        context: context,
        title: "คุณแน่ใจหรือไม่ ? ",
        text: "คุณต้องการอัพเดทข้อมูลสมาชิกหรือไม่ ? ",
        type: QuickAlertType.warning,
        confirmBtnText: "ใช่",
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
        cancelBtnText: "ไม่",
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
      isLoaded = true;
    });
    selectedPet = dogData.first;
  }

  final PetdetailController petdetailController = PetdetailController();
  final MemberController memberController = MemberController();

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("แก้ไขข้อมูลสัตว์เลี้ยง",style: TextStyle(fontFamily: "Itim")),
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
      body: isLoaded == true
          ? Form(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    buildappname(),
                    buildtitle(),
                    buildtypepet(),
                    // buildanimalspice(),
                    buildnamepet(size),
                    buildagepet(size),
                    buildgenderpet(size),
                    buildbuttom(size),
                  ],
                ),
              ),
            )
          : Container(),
    ));
  }

  Row buildgenderpet(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<TypeGender>(
          value: TypeGender.male,
          groupValue: typeGender,
          onChanged: (TypeGender? val) {
            setState(() {
              typeGender = TypeGender.male;
              typegenders = "ชาย";
            });
          },
        ),
        Text('ชาย',style: TextStyle(fontFamily: "Itim")),
        SizedBox(width: 20),
        Radio<TypeGender>(
          value: TypeGender.female,
          groupValue: typeGender,
          onChanged: (TypeGender? val) {
            setState(() {
              typeGender = TypeGender.female;
              typegenders = "หญิง";
            });
          },
        ),
        Text('หญิง',style: TextStyle(fontFamily: "Itim")),
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
                  print("MemberId ${member?.memberId}");
                  Petdetail updatePetdetail = Petdetail(
                    petId: petdetail?.petId,
                    agepet: agePetTextController.text = dropdownage,
                    gender: typegenders,
                    namepet: namePetTextController.text,
                    species: selectedPet,
                    type: types,
                    member: member,
                  );

                  showSureToUpdateMemberAlert(updatePetdetail);
                },
                child: Text("แก้ไขข้อมูลสัตว์เลี้ยง",style: TextStyle(fontFamily: "Itim")))),
      ],
    );
  }

  Container buildtitlespice() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Text("พันธุ์สัตว์",style: TextStyle(fontFamily: "Itim")),
    );
  }

  Container buildtitle() {
    return Container(
      margin: EdgeInsets.only(top: 30),
      child: Text("สัตว์เลี้ยงของท่าน",style: TextStyle(fontFamily: "Itim")),
    );
  }

  Row buildtypepet() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio<Type>(
          value: Type.Dog,
          groupValue: Types,
          onChanged: (Type? val) {
            setState(() {
              Types = Type.Dog;
              types = "สุนัข";
              selectedPet = 'กรุณาเลือกสายพันธุ์';
            });
          },
        ),
        Text('สุนัข'),
        SizedBox(width: 20),
        Radio<Type>(
          value: Type.Cat,
          groupValue: Types,
          onChanged: (Type? val) {
            setState(() {
              Types = Type.Cat;
              types = "แมว";
              selectedPet = 'กรุณาเลือกสายพันธุ์';
            });
          },
        ),
        Text('แมว',style: TextStyle(fontFamily: "Itim")),
        SizedBox(width: 20),
        // if (Types != "แมว")
        DropdownButton<String>(
          hint: Text('เลือกสายพันธุ์',style: TextStyle(fontFamily: "Itim"),),
          value: selectedPet,
          onChanged: (String? newValue) {
            setState(() {
              selectedPet = newValue!;
            });
          },
          items: types == "สุนัข"
              ? dogData.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()
              : catData.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
        ),
      ],
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
            "แก้ไขข้อมูลสัตว์เลี้ยงของท่าน",
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
            ),style: TextStyle(fontFamily: "Itim"),
          ),
        ),
      ],
    );
  }
}
