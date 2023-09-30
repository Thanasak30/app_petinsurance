import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pet_insurance/controller/MemberController.dart';
import 'package:pet_insurance/model/Member.dart';
import 'package:pet_insurance/screen/EditProfile.dart';
import 'package:pet_insurance/screen/View_insurance.dart';
import 'package:pet_insurance/widgets/_buildInfoPair.dart';

class ShowProfile extends StatefulWidget {
  const ShowProfile({super.key});

  @override
  State<ShowProfile> createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile> {
  MemberController memberController = MemberController();

  String? username;
  Member? member;

  bool? isLoaded;

  void syncUser() async {
    setState(() {
      isLoaded = false;
    });
    var usernameSession = await SessionManager().get("username");
    username = usernameSession.toString();
    var response = await memberController.getMemberByUsername(username ?? "");
    member = Member.fromJsonToMember(response);
    print(member?.fullname);
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    syncUser();
  }

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("ข้อมูลส่วนตัว"),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
                return Viewinsurance();
              }),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Card(
            color: Colors.grey,
            child: Column(
              children: [
                buileProfile(),
                buildbuttom(size)
              ],
            ),
          ),
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
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                    return EditProfile();
                  }));
                },
                child: Text("แก้ไขโปรไฟล์"))),
      ],
    );
  }

  Column buileProfile() {
    return Column(
      children: [
        buileinfo(
            label: "ชื่อ-นามสกุล",
            value: '${isLoaded == true ? member?.fullname : ""}'),
        SizedBox(height: 16.0),
        buileinfo(
            label: "เลขบัตรประชาชน",
            value: '${isLoaded == true ? member?.idcard : ""}'),
        SizedBox(height: 16.0),
        buileinfo(
            label: "เพศ", value: '${isLoaded == true ? member?.gender : ""}'),
        SizedBox(height: 16.0),
        buileinfo(
            label: "อายุ", value: '${isLoaded == true ? member?.age : ""}'),
        SizedBox(height: 16.0),
        buileinfo(
            label: "ที่อยู่",
            value: '${isLoaded == true ? member?.address : ""}'),
        SizedBox(height: 16.0),
        buileinfo(
            label: "เบอร์โทร",
            value: '${isLoaded == true ? member?.mobileno : ""}'),
        SizedBox(height: 16.0),
        buileinfo(
            label: "สัญชาติ",
            value: '${isLoaded == true ? member?.nationality : ""}'),
        SizedBox(height: 16.0),
        buileinfo(
            label: "อีเมลล์",
            value: '${isLoaded == true ? member?.member_email : ""}'),
        SizedBox(height: 16.0),
        buileinfo(
            label: "ไอดีไลน์",
            value: '${isLoaded == true ? member?.id_line : ""}'),
        SizedBox(height: 16.0),
      ],
    );
  }
}
