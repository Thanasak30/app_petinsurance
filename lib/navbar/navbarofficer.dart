import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pet_insurance/controller/MemberController.dart';
import 'package:pet_insurance/controller/OfficerController.dart';
import 'package:pet_insurance/model/Officer.dart';
import 'package:pet_insurance/screen/officer/ListAllinsurance.dart';
import 'package:pet_insurance/screen/Listinsurance.dart';
import 'package:pet_insurance/screen/officer/OfficerAddinsurance.dart';

import '../model/Member.dart';
import '../screen/login.dart';
import '../screen/officer/Listinsuranceofficer.dart';

class NavbarOficer extends StatefulWidget {
  const NavbarOficer({super.key});

  @override
  State<NavbarOficer> createState() => _NavbarOficerState();
}

class _NavbarOficerState extends State<NavbarOficer> {
  MemberController memberController = MemberController();
  OfficerController officerController = OfficerController();

  String? username;
  Officer? officer;

  bool? isLoaded;

  void syncUser() async {
    setState(() {
      isLoaded = false;
    });
    var usernameSession = await SessionManager().get("username");
    username = usernameSession.toString();
    var response = await officerController.getOfficerByUsername(username??"");
    officer = Officer.fromJsonToOfficer(response);
    print(officer?.officername);
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
                Text('${isLoaded == true ? officer?.officername : null}'),
            currentAccountPicture: CircleAvatar(
              child: ClipOval(child: Image.asset('Image/pet-insurance.png')),
            ),
            decoration: BoxDecoration(
                color: Colors.teal,
                image: DecorationImage(
                    image: AssetImage('Image/background.png'),
                    fit: BoxFit.cover)),
          ),
          // Text("${username}"),
          ListTile(
            leading: Icon(Icons.home_outlined),
            title: Text("Home"),
            onTap: () => print('Home'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("List Applicant"),
            onTap: (){
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                return ListInsuranceScreen();
              }));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Add insurance"),
            onTap: () {
               Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                return Addinsurance();
              }));
            }
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Sing out"),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                return LoginScreen();
              }));
            },
          )
        ],
      ),
    );
  }
}
