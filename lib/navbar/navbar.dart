import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pet_insurance/controller/MemberController.dart';
import 'package:pet_insurance/controller/PetdetailController.dart';
import 'package:pet_insurance/model/Petdetail.dart';
import 'package:pet_insurance/screen/AddPet.dart';
import 'package:pet_insurance/screen/EditProfile.dart';
import 'package:pet_insurance/screen/ListPet.dart';
import 'package:pet_insurance/screen/ShowProfile.dart';
import 'package:pet_insurance/screen/User/View_insurance2.dart';
import 'package:pet_insurance/screen/View_insurance.dart';
import 'package:pet_insurance/screen/insurance_reg5.dart';
import 'package:pet_insurance/screen/login.dart';

import '../model/Member.dart';
import '../screen/Listinsurance.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  MemberController memberController = MemberController();
  PetdetailController petdetailController = PetdetailController();
  

  String? username;
  Member? member;
  Petdetail? petdetail;

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
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text('${username}'),
            accountEmail:
                Text('${isLoaded == true ? member?.member_email : null}'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(child: Image.asset('Image/pet-insurance (1).png')),
            ),
            decoration: BoxDecoration(
                color: Colors.teal,
                image: DecorationImage(
                    image: AssetImage('Image/backgroundnavbar.jpg'),
                    fit: BoxFit.cover)),
          ),
          // Text("${username}"),
          ListTile(
              leading: Icon(Icons.home_outlined,color: Colors.cyan),
              title: Text("หน้าหลัก"),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return Viewinsurance();
                }));
              }),
          ListTile(
            leading: Icon(Icons.account_circle,color: Colors.cyan),
            title: Text("โปรไฟล์"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                return ShowProfile();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.pets,color: Colors.cyan),
            title: Text("เพิ่มสัตว์เลี้ยง"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                return AddPet();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.view_timeline,color: Colors.cyan),
            title: Text("รายการสัตว์เลี้ยง"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                return ListPet();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.receipt_long,color: Colors.cyan),
            title: Text("รายการกรรมธรรม์"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                return ListInsurance();
              }));
            },
          ),
          const Divider(),
          ListTile(
              leading: Icon(Icons.logout,color: Colors.cyan),
              title: Text("Sing out"),
              onTap: () {
                SessionManager().remove("username");
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (BuildContext context) {
                  return Viewinsurance2();
                }));
              })
        ],
      ),
    );
  }
}
