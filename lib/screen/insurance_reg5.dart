import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pet_insurance/screen/insurance_reg4.dart';

class InsuranceREG5 extends StatefulWidget {
  const InsuranceREG5({super.key});

  @override
  State<InsuranceREG5> createState() => _InsuranceREG5State();
}

class _InsuranceREG5State extends State<InsuranceREG5> {
  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("สรุปความคุ้มครองและชำระเงิน"),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return InsuranceREG4(
                pet_id: '', insurance_planId: '',
              );
            }));
          },
        ),
      ),
      body: Form(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "ข้อมูลผู้เอาประกัน",
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("ชื่อผู้เอาประกันภัย"),
                Text("ชื่อผู้เอาประกันภัย")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text("วัน/เดือน/ปีเกิด"), Text("วัน/เดือน/ปีเกิด")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text("เลขบัตรประชาชน"), Text("เลขบัตรประชาชน")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("ที่อยู่ผู้เอาประกัน"),
                Text("ที่อยู่ผู้เอาประกัน")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text("เบอร์โทรศัพท์"), Text("เบอร์โทรศัพท์")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("ที่อยู่จัดส่งใบเสร็จ"),
                Text("ที่อยู่จัดส่งใบเสร็จ")
              ],
            ),
            Divider(),
            Text(
              "อีเมลสำหรับจัดส่งเอกสาร",
              style: TextStyle(fontSize: 20),
            ),
            Text("อีเมลสำหรับจัดส่งเอกสาร"),
            Divider(),
            Text(
              "รายละเอียดสัตว์เลี้ยง",
              style: TextStyle(fontSize: 20),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text("ชื่อสัตว์เลี้ยง"), Text("ชื่อสัตว์เลี้ยง")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text("สายพันธุ์"), Text("สายพันธุ์")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text("พันธุ์สัตว์"), Text("พันธุ์สัตว์")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text("อายุ"), Text("อายุ")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text("เพศ"), Text("เพศ")],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("รายละเอียดกรมธรรม์", style: TextStyle(fontSize: 20))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text("แผนประกันภัย"), Text("แผนประกันภัย")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [Text("ทุนประกันภัย"), Text("ทุนประกันภัย")],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("วันเริ่มต้นคุ้มครอง"),
                Text("วันเริ่มต้นคุ้มครอง")
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("วันสิ้นสุดคุ้มครอง"),
                Text("วันสิ้นสุดคุ้มครอง")
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("ราคาเบี้ยประกันรวม", style: TextStyle(fontSize: 20)),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("ราคาเบี้ยประกันรวม", style: TextStyle(fontSize: 20)),
              ],
            ),
            Row(
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
                          // Navigator.of(context).pushReplacement(
                          //     MaterialPageRoute(
                          //         builder: (BuildContext context) {
                          //   return InsuranceREG5();
                          // }));
                        },
                        child: Text("ชำระเงิน"))),
              ],
            )
          ],
        ),
      )),
    );
  }
}
