import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';

import 'AddPet.dart';
import 'insurance_reg3.dart';

class InsuranceREG4 extends StatefulWidget {
  const InsuranceREG4({super.key});

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

  var type;
  var typeSpice;

  String? types;
  String? typespices;
  String? species;

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

  String listanimal = listanimal_Spice.first;
  String listage = listAge.first;

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("แผนประกัน"),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return InsuranceREG3();
            }));
          },
        ),
      ),
      body: SingleChildScrollView(
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
            Text("ระยะเวลาคุ้มครอง"),
            Text("วันที่คุ้มครอง"),
            Text("วันนี้ ถึง ปีหน้า"),
            Text("ข้อมูลสัตว์เลี้ยง"),
            const Divider(),
            buildnamepet(size),
            buildagepet(size),
            buildgenderpet(size),
            buildtitle(),
            buildtypepet(),
            buildtitlespice(),
            buildtypespice(),
            buildanimalspice(),
            const Divider(),
            Text("เพิ่มรูปภาพสัตว์เลี้ยง"),
            const Divider(),
            Text("เอกสารประกอบการยื่นประกันภัย"),
            Text("ใบรับรองการทำวัคซีนหรือใบตรวจสุขภาพ"),
            Text("รูปภาพ"),
            const Divider(),
            Text("วิธีการรับกรมธรรม์"),
            Text("radio"),
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
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.3,
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
          width: size * 0.3,
          child: TextFormField(
            controller: fullnameTextController,
            decoration: InputDecoration(
              labelText: "คำนำหน้า",
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
          width: size * 0.5,
          child: TextFormField(
            controller: fullnameTextController,
            decoration: InputDecoration(
              labelText: "fullname",
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
