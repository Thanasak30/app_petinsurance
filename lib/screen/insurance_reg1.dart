import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'insurance_reg2.dart';

class InsuranceREG extends StatefulWidget {
  const InsuranceREG({super.key});

  @override
  State<InsuranceREG> createState() => _InsuranceREGState();
}

const List<String> listPet = <String>['1', '2'];

class _InsuranceREGState extends State<InsuranceREG> {
  String listpet = listPet.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("สมัครแผนประกัน"),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("เลือกสัตว์เลี้ยงที่ต้องการทำประกัน"),
            buildlistpet(),
          ],
        ),
      ),
    );
  }

  Row buildlistpet() {
    return Row(
      children: [
        Expanded(child: Text("สัตว์เลี้ยง", style: TextStyle(fontSize: 15))),
        Expanded(
          child: DropdownButton<String>(
            value: listpet,
            isExpanded: true,
            onChanged: (String? val) {
              setState(() {
                listpet = val!;
              });
            },
            items: listPet.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                return InsuranceREG2();
              }));
            },
            child: Text("ต่อไป"))
      ],
    );
  }
}
