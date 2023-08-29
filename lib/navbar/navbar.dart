import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pet_insurance/controller/MemberController.dart';

import '../model/Member.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {

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
    var response = await memberController.getMemberByUsername(username??"");
    member = Member.fromJsonToMember(response);
    print(member?.fullname);
    setState(() {
      isLoaded = true;
    });
  }

  @override
  void initState()  {
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
            accountEmail: Text('${isLoaded == true? member?.member_email : null}'),
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
            leading: Icon(Icons.account_circle),
            title: Text("Insurance Pet"),
            onTap: () => print('Insurance Pet'),
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text("Setting"),
            onTap: () => print('Setting'),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Sing out"),
            onTap: () => print('Sing out'),
          )
        ],
      ),
    );
  }
}
