import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pet_insurance/model/Member.dart';
import 'package:pet_insurance/screen/ShowProfile.dart';
import 'package:pet_insurance/screen/View_insurance.dart';
import 'package:quickalert/quickalert.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../controller/MemberController.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String? user;
  Member? member;
  bool? isLoaded;

  var dateFormat = DateFormat('dd-MM-yyyy');
  DateTime currentDate = DateTime.now();
  DateTime? birthday;

  final MemberController memberController = MemberController();

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
  TextEditingController usernameController = TextEditingController();
  
  void fetcData() async {
    user = await SessionManager().get("username");
    print(user);
    member = await memberController.getMemberById(user!);
    print("testusername ${member?.username?.username}");
    setState(() {
      fullnameTextController.text = member?.fullname ?? "";
      AgeTextController.text = member?.age ?? "";
      GenderTextController.text = member?.gender ?? "";
      nationalityTextController.text = member?.nationality ?? "";
      MobilenumberTextController.text = member?.mobileno ?? "";
      EmailTextController.text = member?.member_email ?? "";
      IdCardTextController.text = member?.idcard ?? "";
      AdddressTextController.text = member?.address ?? "";
      IDlineTextController.text = member?.id_line ?? "";
      birthdayTextController.text = dateFormat.format(member?.brithday?? DateTime.now());
      isLoaded = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetcData();
  }
  void showSureToUpdateMemberAlert (Member uMember) {
    QuickAlert.show(
      context: context,
      title: "คุณแน่ใจหรือไม่ ? ",
      text: "คุณต้องการอัพเดทข้อมูลสมาชิกหรือไม่ ? ",
      type: QuickAlertType.warning,
      confirmBtnText: "แก้ไข",
      onConfirmBtnTap: () async {
        http.Response response = await memberController.updateMember(uMember);
                  
        if (response.statusCode == 200){
          Navigator.pop(context);
          showUpdateMemberSuccessAlert();
        }else {
          showFailToUpdateMemberAlert();
        }
      },
      cancelBtnText: "ยกเลิก",
      showCancelBtn: true
    );
  }

  void showFailToUpdateMemberAlert () {
    QuickAlert.show(
      context: context, 
      title: "เกิดข้อผิดพลาด",
      text: "ไม่สามารถอัพเดทข้อมูลสมาชิกได้",
      type: QuickAlertType.error
    );
  }

  void showUpdateMemberSuccessAlert () {
    QuickAlert.show(
      context: context, 
      title: "สำเร็จ",
      text: "อัพเดทข้อมูลสำเร็จ",
      type: QuickAlertType.success,
      confirmBtnText: "ตกลง",
      onConfirmBtnTap: (){
        Navigator.of(context).pushReplacement(       
          MaterialPageRoute(builder: (context) => const EditProfile())
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("ข้อมูลส่วนตัว"),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return ShowProfile();
            }));
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildfullname(size),
            buildage(size),
            buildgender(size),
            buildnationality(size),
            buildIDcard(size),
            buildmobile(size),
            buildbirthday(size),
            buildemail(size),
            buildaddress(size),
            buildidline(size),
            buildbuttom(size),
          ],
        ),
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
                  Member updateMember = Member(
                    memberId: member?.memberId,
                    age: AgeTextController.text,
                    mobileno: MobilenumberTextController.text,
                    member_email: EmailTextController.text,
                    gender: GenderTextController.text,
                    fullname: fullnameTextController.text,
                    idcard: IdCardTextController.text,
                    address: AdddressTextController.text,
                    brithday: dateFormat.parse(birthdayTextController.text),
                    nationality: nationalityTextController.text,
                    id_line: IDlineTextController.text,
                    username: member?.username
                  );
                  // print(updateMember?.username?.username);
                  showSureToUpdateMemberAlert(updateMember);
                },
                child: Text("แก้ไขข้อมูล"))),
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
                    birthdayTextController.text = 
                    dateFormat.format(birthday!);
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

  Row buildgender(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
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

  Row buildage(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
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
      ],
    );
  }

  Row buildfullname(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
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
