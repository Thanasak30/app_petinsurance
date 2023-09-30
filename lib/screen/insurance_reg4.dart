import 'dart:io';

import 'package:file_picker/src/platform_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pet_insurance/controller/PetdetailController.dart';
import 'package:pet_insurance/model/Petdetail.dart';
import 'package:pet_insurance/screen/View_insurance.dart';
import 'package:pet_insurance/screen/insurance_reg2.dart';
import 'package:http/http.dart' as http;
import 'package:pet_insurance/screen/insurance_reg5.dart';
import '../controller/MemberController.dart';
import '../model/Member.dart';
import 'AddPet.dart';
import 'insurance_reg3.dart';

class InsuranceREG4 extends StatefulWidget {
  final String pet_id;
  final String insurance_planId;
  const InsuranceREG4(
      {Key? key, required this.pet_id, required this.insurance_planId})
      : super(key: key);

  @override
  State<InsuranceREG4> createState() => _InsuranceREG4State();
}

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

class _InsuranceREG4State extends State<InsuranceREG4> {
  var dateFormat = DateFormat('dd-MM-yyyy');
  DateTime currentDate = DateTime.now();
  DateTime? birthday;
  DateTime nextYearDate =
      DateTime.now().add(Duration(days: 365 + 1)); //xรอคูนกับ duration

  String? type;
  String? typeSpice;

  String? types;
  String? typespices;
  String? species;

  String? user;
  Member? member;
  bool? isLoaded;

  Petdetail? petdetail;

  FilePickerResult? filePickerResult;
  PlatformFile? pickedFile;
  File? fileToDisplay;
  String? fileName;
  bool isLoadingPicture = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final MemberController memberController = MemberController();
  final PetdetailController petdetailController = PetdetailController();

  TextEditingController fullnameTextController = TextEditingController();
  TextEditingController AgeTextController = TextEditingController();
  TextEditingController GenderTextController = TextEditingController();
  TextEditingController nationalityTextController = TextEditingController();
  TextEditingController MobilenumberTextController = TextEditingController();
  TextEditingController birthdayTextController = TextEditingController();
  TextEditingController EmailTextController = TextEditingController();
  TextEditingController IdCardTextController = TextEditingController();
  TextEditingController AdddressTextController = TextEditingController();
  TextEditingController IDlineTextController = TextEditingController();
  TextEditingController namePetTextController = TextEditingController();
  TextEditingController agePetTextController = TextEditingController();
  TextEditingController genderpetTextController = TextEditingController();
  TextEditingController TypeTextController = TextEditingController();
  TextEditingController animal_speciesController = TextEditingController();
  TextEditingController speciesController = TextEditingController();

  TextEditingController InsuranceImg = TextEditingController();

  String listanimal = listanimal_Spice.first;
  String listage = listAge.first;

  void setData() async {
    fullnameTextController.text = member?.fullname ?? "";
    AgeTextController.text = member?.age ?? "";
    GenderTextController.text = member?.gender ?? "";
    nationalityTextController.text = member?.nationality ?? "";
    MobilenumberTextController.text = member?.mobileno ?? "";
    EmailTextController.text = member?.member_email ?? "";
    IdCardTextController.text = member?.idcard ?? "";
    AdddressTextController.text = member?.address ?? "";
    IDlineTextController.text = member?.id_line ?? "";
    birthdayTextController.text =
        dateFormat.format(member?.brithday ?? DateTime.now());
    namePetTextController.text = petdetail?.namepet ?? "";
    agePetTextController.text = petdetail?.agepet ?? "";
    genderpetTextController.text = petdetail?.gender ?? "";
    TypeTextController.text = petdetail?.type ?? "";
    speciesController.text = petdetail?.species ?? "";
    animal_speciesController.text = petdetail?.animal_species ?? "";
  }

  void petdata(String petId) async {
    user = await SessionManager().get("username");
    member = await memberController.getMemberById(user!);
    print("testusername ${member?.username?.username}");
    print(user);
    setState(() {
      isLoaded = false;
    });
    var response = await petdetailController.getPetdetailById(petId);
    petdetail = Petdetail.fromJsonToPetdetail(response);
    print(response);
    setData();
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
    });
  }

  @override
  Widget build(BuildContext context) {
    void _pickFile() async {
      try {
        setState(() {
          isLoadingPicture = true;
        });
        filePickerResult = await FilePicker.platform
            .pickFiles(allowMultiple: false, type: FileType.image);
        if (filePickerResult != null) {
          fileName = filePickerResult!.files.first.name;
          pickedFile = filePickerResult!.files.first;
          fileToDisplay = File(pickedFile!.path.toString());
          InsuranceImg.text = fileName.toString();
          print("File is ${fileName}");
        }
        setState(() {
          isLoadingPicture = false;
        });
      } catch (e) {
        print(e);
      }
    }

    double size = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("แผนประกัน"),
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                return InsuranceREG2(
                  pet_id: '',
                );
              }));
            },
          ),
        ),
        body: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("ข้อมูลส่วนตัว"), //ดึงค่าออกมาแสดง
                buildfullname(size),
                buildAge(size),
                buildnationality(size),
                buildIDcard(size),
                buildmobile(size),
                buildbirthday(size),
                buildemail(size),
                buildaddress(size),
                buildidline(size),
                const Divider(),
                buildDate(),
                const Divider(),
                Text("ข้อมูลสัตว์เลี้ยง"),
                const Divider(),
                buildnamepet(size),
                buildagepet(size),
                buildgenderpet(size),
                buildtitle(),
                buildtypepet(),
                buildtitlespice(),
                buildtypespice(),
                buildanimalspice(size),
                const Divider(),
                Text("เพิ่มรูปภาพสัตว์เลี้ยง"),
                builImage(_pickFile),
                const Divider(),
                Text("เอกสารประกอบการยื่นประกันภัย"),
                Text("ใบรับรองการทำวัคซีนหรือใบตรวจสุขภาพ"),
                Text("รูปภาพ"),
                const Divider(),
                Text("วิธีการรับกรมธรรม์"),
                Text("radio"),
                buildbuttom(size)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row builImage(void _pickFile()) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              controller: InsuranceImg,
              enabled: false,
              decoration: InputDecoration(
                  labelText: "รูปภาพหน้าตรง",
                  counterText: "",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  prefixIcon: const Icon(Icons.image),
                  prefixIconColor: Colors.black),
              style: const TextStyle(fontFamily: 'Itim', fontSize: 18),
            ),
          ),
        ),
        Expanded(
            flex: 1,
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _pickFile();
                },
                child: const Text("เลือกรูปภาพ"),
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.grey)),
              ),
            )),
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
                  // http.Response response = await petdetailController.addPet(
                  //   "-",
                  //   "flase",
                  //   listage.toString(),
                  //   genderpetTextController.text,
                  //   "-",
                  //   namePetTextController.text,
                  //   typespices.toString(),
                  //   types.toString(),
                  //   member!.memberId.toString(),
                  //   listanimal.toString(),
                  //   "flase",
                  // );
                  // if (response.statusCode == 500) {
                  //   print("Error!");
                  // } else {
                  //   print("Member was added successfully!");
                  // }
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                    return InsuranceREG5();
                  }));
                },
                child: Text("ต่อไป"))),
      ],
    );
  }

  Row buildDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            Text("ระยะเวลาคุ้มครอง"),
            Text("วันที่คุ้มครอง"),
            Text(
                '${dateFormat.format(currentDate)} ถึง ${dateFormat.format(nextYearDate)}'),
          ],
        ),
      ],
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

  Row buildanimalspice(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: size * 0.6,
          child: TextFormField(
            controller: animal_speciesController,
            decoration: InputDecoration(
              labelText: "สายพันธุ์",
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: size * 0.6,
          child: TextFormField(
            controller: agePetTextController,
            decoration: InputDecoration(
              labelText: "อายุ",
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

  Row buildaddress(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: AdddressTextController,
            decoration: InputDecoration(
              labelText: "ที่อยู่",
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

  Row buildemail(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: EmailTextController,
            decoration: InputDecoration(
              labelText: "อีเมลล์",
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

  Row buildidline(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: IDlineTextController,
            decoration: InputDecoration(
              labelText: "ไอดีไลน์",
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

  Row buildbirthday(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            onTap: () async {
              DateTime? tempDate = await showDatePicker(
                  context: context,
                  initialDate: currentDate,
                  firstDate: DateTime(1950),
                  lastDate: DateTime(2100));
              setState(() {
                birthday = tempDate;
                birthdayTextController.text = dateFormat.format(birthday!);
              });
              print(birthday);
            },
            readOnly: true,
            controller: birthdayTextController,
            decoration: InputDecoration(
              labelText: "วัน/เดือน/ปีเกิด",
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

  Row buildmobile(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: MobilenumberTextController,
            decoration: InputDecoration(
              labelText: "หมายเลขโทรศัพท์",
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

  Row buildIDcard(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: IdCardTextController,
            decoration: InputDecoration(
              labelText: "บัตรประชาชน 13 หลัก",
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

  Row buildnationality(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: nationalityTextController,
            decoration: InputDecoration(
              labelText: "สัญชาติ",
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

  Row buildAge(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.2,
          child: TextFormField(
            controller: AgeTextController,
            decoration: InputDecoration(
              labelText: "อายุ",
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
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.3,
          child: TextFormField(
            controller: GenderTextController,
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

  Row buildfullname(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.5,
          child: TextFormField(
            controller: fullnameTextController,
            decoration: InputDecoration(
              labelText: "ชื่อ - นามสกุล",
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
