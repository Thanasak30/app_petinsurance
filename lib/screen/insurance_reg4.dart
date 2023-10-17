import 'dart:io';

import 'package:http_parser/http_parser.dart';
import 'package:file_picker/src/platform_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:pet_insurance/controller/Insuranceregister.dart';
import 'package:pet_insurance/controller/PetdetailController.dart';
import 'package:pet_insurance/model/Petdetail.dart';
import 'package:pet_insurance/model/Petinsuranceregister.dart';
import 'package:pet_insurance/screen/View_insurance.dart';
import 'package:pet_insurance/screen/insurance_reg2.dart';
import 'package:http/http.dart' as http;
import 'package:pet_insurance/screen/insurance_reg5.dart';
import '../controller/MemberController.dart';
import '../controller/OfficerController.dart';
import '../model/Insurancedetail.dart';
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

enum Type { receivedByEmail }

var typereceived;
String? typesreceived;

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
  Petinsuranceregister? petinsuranceregister;

  FilePickerResult? filePickerResult;
  PlatformFile? pickedFile;
  File? fileToDisplay;
  String? fileName;
  File? _image;
  File? _images;
  File? _imagepet;
  bool isLoadingPicture = true;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final MemberController memberController = MemberController();
  final PetdetailController petdetailController = PetdetailController();
  final InsuranceREG insuranceREG = InsuranceREG();

  final String baseURL = 'https://example.com';

  List<Insurancedetail>? insurancedetail;
  Insurancedetail? insurancedetails;

  OfficerController officerController = OfficerController();

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
  TextEditingController InsuranceImghealth = TextEditingController();

  String listanimal = listanimal_Spice.first;
  String listage = listAge.first;

  Future getImage() async {
    final picker = ImagePicker();
    var image = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = File(image!.path);
    });
  }

  Future getImagehealth() async {
    final picker = ImagePicker();
    var images = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _images = File(images!.path);
    });
  }

  Future getImagepet() async {
    final picker = ImagePicker();
    var imagepet = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _imagepet = File(imagepet!.path);
    });
  }

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
    insurancedetail = await officerController.listAllInsurance();
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("แผนประกัน"),
          leading: BackButton(
            color: Colors.white,
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) {
                  return InsuranceREG2(
                    pet_id: petdetail!.petId.toString(),
                  );
                },
              ));
            },
          ),
        ),
        body: Form(
           key: formKey,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 16),
                Text(
                  "ข้อมูลส่วนตัว",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
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
                Text(
                  "ข้อมูลสัตว์เลี้ยง",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                buildnamepet(size),
                buildagepet(size),
                buildgenderpet(size),
                buildtypepet(size),
                buildtypespice(size),
                buildanimalspice(size),
                const Divider(),
                buildimgpet(),
                const Divider(),
                buildimgdocument(),
                const Divider(),
                Text(
                  "วิธีรับกรรมธรรม์",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                buildraio(),
                SizedBox(height: 20),
                Center(child: buildbuttom(size)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  RadioListTile<Type> buildraio() {
    return RadioListTile<Type>(
      value: Type.receivedByEmail,
      groupValue: typereceived,
      title: Text("รับกรมธรรม์ทางอีเมล"),
      onChanged: (Type? val) {
        setState(() {
          typereceived = Type.receivedByEmail;
          typesreceived = "รับกรมธรรม์ทางอีเมล";
        });
        validator:
        (value) {
          // กรณีไม่กรอกไอดีไลน์
          if (value!.isEmpty) {
            return "กรุณาเลือกวิธีรับกรรมธรรม์";
          }
        };
      },
    );
  }

  Padding buildimgpet() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "เพิ่มรูปภาพสัตว์เลี้ยง",
            style: TextStyle(
              fontWeight: FontWeight.bold, // ตั้งค่าให้ตัวหนา
              fontSize: 20, // ตั้งค่าขนาดฟอนต์เป็น 24
            ),
          ),
          _image == null
              ? Text('No image selected.')
              : Image.file(
                  _image!,
                  height: 100,
                ),
          SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30))),
            onPressed: getImage,
            child: Text('Select Image'),
          ),
        ],
      ),
    );
  }

  Padding buildimgdocument() {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("เอกสารประกอบการยื่นประกันภัย",
              style: TextStyle(
                fontWeight: FontWeight.bold, // ตั้งค่าให้ตัวหนา
                fontSize: 20, // ตั้งค่าขนาดฟอนต์เป็น 24
              )),
          Text("ใบรับรองการทำวัคซีนและใบตรวจสุขภาพ",
              style: TextStyle(
                fontWeight: FontWeight.bold, // ตั้งค่าให้ตัวหนา
                fontSize: 15, // ตั้งค่าขนาดฟอนต์เป็น 24
              )),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  _images == null
                      ? Text('No image selected.')
                      : Image.file(
                          _images!,
                          height: 100,
                        ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: getImagehealth,
                    child: Text('Select Image'),
                  ),
                ],
              ),
              SizedBox(width: 20),
              Column(
                children: <Widget>[
                  _imagepet == null
                      ? Text('No image selected.')
                      : Image.file(
                          _imagepet!,
                          height: 100,
                        ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: getImagepet,
                    child: Text('Select Image'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
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
                  print(widget.insurance_planId);
                  print(nextYearDate);
                  print(widget.pet_id);
                  if (formKey.currentState!.validate()) {
                  http.Response response = await insuranceREG.addInsuranceReg(
                    widget.insurance_planId,
                    member!.memberId.toString(),
                    typesreceived.toString(),
                    dateFormat.format(currentDate),
                    dateFormat.format(nextYearDate),
                    "",
                    _imagepet!,
                    _image!,
                    _images!,
                    widget.pet_id,
                  );
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                    return Viewinsurance();
                  }));
                  if (response.statusCode == 500) {
                    print("Error!");
                  } else {
                    print("Member was added successfully!");
                  }
                }
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
            Text("ระยะเวลาคุ้มครอง",
                style: TextStyle(
                  fontWeight: FontWeight.bold, // ตั้งค่าให้ตัวหนา
                  fontSize: 20, // ตั้งค่าขนาดฟอนต์เป็น 24
                )),
            Text("วันที่คุ้มครอง",
                style: TextStyle(
                  fontWeight: FontWeight.bold, // ตั้งค่าให้ตัวหนา
                  fontSize: 15, // ตั้งค่าขนาดฟอนต์เป็น 24
                )),
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

  Row buildtypespice(size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: size * 0.6,
          child: TextFormField(
            controller: speciesController,
            decoration: InputDecoration(
              labelText: "พันธุ์สัตว์",
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

  Row buildtypepet(size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 30),
          width: size * 0.6,
          child: TextFormField(
            controller: TypeTextController,
            decoration: InputDecoration(
              labelText: "สัตว์เลี้ยงของท่าน",
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
              labelText: "อายุของสัตว์เลี้ยง",
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
              labelText: "ชื่อสัตว์เลี้ยง",
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
