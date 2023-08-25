import 'dart:developer';

import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
              accountName: Text('golf'), 
              accountEmail: Text('golf@gmail.com'),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(child: Image.asset('Image/pet-insurance.png')),
              ),
              decoration: BoxDecoration(
                color: Colors.teal,
                image: DecorationImage(image: AssetImage('Image/background.png'),fit: BoxFit.cover)
              ) ,
              ),
              ListTile(
                leading: Icon(Icons.home_outlined),
                title: Text("Home"),
                onTap: ()=>print('Home'),
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text("Insurance Pet"),
                onTap: ()=>print('Insurance Pet'),
              ),
              Divider(),
               ListTile(
                leading: Icon(Icons.settings),
                title: Text("Setting"),
                onTap: ()=>print('Setting'),
              ),
               ListTile(
                leading: Icon(Icons.logout),
                title: Text("Sing out"),
                onTap: ()=>print('Sing out'),
              )
        ],
      ),
    );
  }
}
