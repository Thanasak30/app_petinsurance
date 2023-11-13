import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pet_insurance/controller/OfficerController.dart';
import 'package:pet_insurance/model/Insurancedetail.dart';
import 'package:pet_insurance/model/Officer.dart';
import 'package:pet_insurance/screen/AddPet.dart';
import 'package:pet_insurance/screen/insurance_reg1.dart';

import '../controller/MemberController.dart';
import '../controller/PetdetailController.dart';
import '../model/Member.dart';
import '../model/Petdetail.dart';
import '../navbar/navbar.dart';
import 'AddPet2.dart';

class Viewinsurance extends StatefulWidget {
  const Viewinsurance({
    Key? key,
  }) : super(key: key);

  @override
  State<Viewinsurance> createState() => _ViewinsuranceState();
}

class _ViewinsuranceState extends State<Viewinsurance> {
  final petdetailController = PetdetailController();
  List<Petdetail>? petdetail;
  Member? member;
  String? user;
  String? substring;
  String? strprice;

  List<Insurancedetail>? insurancedetail;
  Insurancedetail? insurancedetails;
  bool? isLoaded;

  OfficerController officerController = OfficerController();
  final MemberController memberController = MemberController();

  void fetcData() async {
    setState(() {
      isLoaded = false;
    });
    user = await SessionManager().get("username");
    print(user);
    member = await memberController.getMemberById(user!);
    petdetail = await petdetailController
        .listAllPetdetailByMember(member!.memberId.toString());
    insurancedetail = await officerController.listAllInsurance();
    setState(() {
      isLoaded = true;
    });
  }

  void _showPopup(BuildContext context, int i) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        substring = insurancedetail?[i]
            .price
            .toString()
            .substring(0, insurancedetail?[i].price.toString().indexOf('.'));
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          title:
              Text("รายละเอียดเพิ่มเติม", style: TextStyle(fontFamily: "Itim")),
          content: Container(
            height: 420,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ชื่อแผนประกันภัย",
                        style: TextStyle(fontFamily: "Itim")),
                    Text("${insurancedetail?[i].insurance_name}",
                        style: TextStyle(fontFamily: "Itim")),
                  ],
                ),
                Divider(
                  indent: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ราคาแผน", style: TextStyle(fontFamily: "Itim")),
                    Text("$substring บาท",
                        style: TextStyle(fontFamily: "Itim")),
                  ],
                ),
                Divider(
                  indent: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ค่ารักษาพยาบาล",
                        style: TextStyle(fontFamily: "Itim")),
                    insurancedetail?[i].medical_expenses == "ไม่คุ้มครอง"
                        ? Text("${insurancedetail?[i].medical_expenses} ",
                            style: TextStyle(fontFamily: "Itim"))
                        : Text("${insurancedetail?[i].medical_expenses} บาท",
                            style: TextStyle(fontFamily: "Itim")),
                  ],
                ),
                Divider(
                  indent: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ค่ารักษาพยาบาลจาก\nการเจ็บป่วย",
                        style: TextStyle(fontFamily: "Itim")),
                    insurancedetail?[i].treatment == "ไม่คุ้มครอง"
                        ? Text("${insurancedetail?[i].treatment} ",
                            style: TextStyle(fontFamily: "Itim"))
                        : Text("${insurancedetail?[i].treatment} บาท",
                            style: TextStyle(fontFamily: "Itim")),
                  ],
                ),
                Divider(
                  indent: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ชีวิตและร่างกายของ\nบุคคลภายนอก",
                        style: TextStyle(fontFamily: "Itim")),
                    insurancedetail?[i].pets_attack_outsiders == "ไม่คุ้มครอง"
                        ? Text("${insurancedetail?[i].pets_attack_outsiders} ",
                            style: TextStyle(fontFamily: "Itim"))
                        : Text(
                            "${insurancedetail?[i].pets_attack_outsiders} บาท",
                            style: TextStyle(fontFamily: "Itim")),
                  ],
                ),
                Divider(
                  indent: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ทรัพย์สินบุคคลภายนอก",
                        style: TextStyle(fontFamily: "Itim")),
                    insurancedetail?[i]
                                .third_party_property_values_due_to_pets ==
                            "ไม่ค้มครอง"
                        ? Text(
                            "${insurancedetail?[i].third_party_property_values_due_to_pets} ",
                            style: TextStyle(fontFamily: "Itim"))
                        : Text(
                            "${insurancedetail?[i].third_party_property_values_due_to_pets} บาท",
                            style: TextStyle(fontFamily: "Itim")),
                  ],
                ),
                Divider(
                  indent: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ค่าใช้จ่ายจัดพิธีศพ\nสัตว์เลี้ยง",
                        style: TextStyle(fontFamily: "Itim")),
                    insurancedetail?[i].pet_funeral_costs == "ไม่คุ้มครอง"
                        ? Text("${insurancedetail?[i].pet_funeral_costs} ",
                            style: TextStyle(fontFamily: "Itim"))
                        : Text("${insurancedetail?[i].pet_funeral_costs} บาท",
                            style: TextStyle(fontFamily: "Itim")),
                  ],
                ),
                Divider(
                  indent: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "ค่าชดเชยกรณีสัตว์เลี้ยง\nเสียชีวิตจากอุบัติเหตุ\nหรือการป่วย",
                        style: TextStyle(fontFamily: "Itim")),
                    insurancedetail?[i].accident_or_illness_compensation ==
                            "ไม่คุ้มครอง"
                        ? Text(
                            "${insurancedetail?[i].accident_or_illness_compensation}",
                            style: TextStyle(fontFamily: "Itim"))
                        : Text(
                            "${insurancedetail?[i].accident_or_illness_compensation} บาท",
                            style: TextStyle(fontFamily: "Itim")),
                  ],
                ),
                Divider(
                  indent: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("ค่าวัคซีนป้องกันโรค\nในสัตว์เลี้ยง",
                        style: TextStyle(fontFamily: "Itim")),
                    insurancedetail?[i].cost_of_preventive_vaccination ==
                            "ไม่คุ้มครอง"
                        ? Text(
                            "${insurancedetail?[i].cost_of_preventive_vaccination}",
                            style: TextStyle(fontFamily: "Itim"))
                        : Text(
                            "${insurancedetail?[i].cost_of_preventive_vaccination} บาท",
                            style: TextStyle(fontFamily: "Itim"),
                          )
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close', style: TextStyle(fontFamily: "Itim")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetcData();
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    CarouselController carouselController = CarouselController();

    return SafeArea(
      child: Scaffold(
        drawer: Navbar(),
        appBar: AppBar(
          title: Center(
              child: const Text(
            "หน้าหลัก",
            style: TextStyle(
              fontFamily: "Itim",
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
        body:isLoaded == false? Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  builddata(width),
                  builddata2(width),
                  SizedBox(
                    height: 500, // กำหนดความสูงของ Carousel ตามต้องการ
                    child: buildcarousel(carouselController),
                  ),
                ],
              ),
            ),
          ],
        ):CircularProgressIndicator(),
      ),
    );
  }

  CarouselSlider buildcarousel(CarouselController carouselController) {
    return CarouselSlider.builder(
      itemCount: insurancedetail?.length ??
          0, // ให้ itemCount เป็น 0 ถ้า insurancedetail เป็น null
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        final plan = insurancedetail?[itemIndex];
        strprice = plan?.price
            .toString()
            .substring(0, plan.price.toString().indexOf('.'));
        // กำหนดสีให้แต่ละแผน
        Color planColor = Colors.cyan; // สีตั้งต้น
        if (itemIndex == 1) {
          planColor = Colors.red; // สีสำหรับแผนที่ 2
        } else if (itemIndex == 2) {
          planColor = Colors.green; // สีสำหรับแผนที่ 3
        } else if (itemIndex == 3) {
          planColor = Colors.orange; // สีสำหรับแผนที่ 4
        } else if (itemIndex == 4) {
          planColor = Colors.pink; // สีสำหรับแผนที่ 5
        } else if (itemIndex == 5) {
          planColor = Colors.yellowAccent; // สีสำหรับแผนที่ 6
        }
        return Container(
          width: double.infinity,
          margin: EdgeInsets.all(16),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.cyan),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 140, // กำหนดความกว้างของ Container ที่ต้องการ
                child: Container(
                  decoration: BoxDecoration(
                    color: plan?.insurance_name != null
                        ? planColor
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(180),
                  ),
                  child: Center(
                    child: Text(
                      plan?.insurance_name ?? "",
                      style: TextStyle(
                          color: Color.fromARGB(255, 24, 22, 53),
                          fontSize: 30,
                          fontFamily: "Itim"),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text("$strprice บาท",
                  style: TextStyle(fontSize: 18, fontFamily: "Itim")),
              SizedBox(height: 8),
              Text(
                "ค่ารักษาจากอุบัติเหตุ(บาท)",
                style: TextStyle(fontSize: 14, fontFamily: "Itim"),
              ),
              SizedBox(height: 8),
              Text(
                "${plan?.medical_expenses ?? ""}",
                style: TextStyle(fontSize: 14, fontFamily: "Itim"),
              ),
              Text(
                "ค่ารักษาจากการเจ็บป่วย(บาท) ",
                style: TextStyle(fontSize: 14, fontFamily: "Itim"),
              ),
              SizedBox(height: 8),
              Text(
                "${plan?.treatment} ",
                style: TextStyle(fontSize: 14, fontFamily: "Itim"),
              ),
              SizedBox(height: 8),
              Text(
                "ค่าวัคซีนป้องกันโรคสัตว์เลี้ยง(บาท)",
                style: TextStyle(fontSize: 14, fontFamily: "Itim"),
              ),
              SizedBox(height: 8),
              Text(
                "${plan?.cost_of_preventive_vaccination}",
                style: TextStyle(fontSize: 14, fontFamily: "Itim"),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  _showPopup(context, itemIndex);
                },
                child: Text("รายละเอียด", style: TextStyle(fontFamily: "Itim")),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                onPressed: () {
                  print("${plan?.insurance_planId}");
                  if (petdetail?.length != 0) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => InsuranceREG(
                              insurance_planId: plan?.insurance_planId ?? 0,
                            )));
                  } else {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return AddPet();
                    }));
                  }
                },
                child: Text(
                  "สมัครแผน",
                  style: TextStyle(fontFamily: "Itim",color: Color.fromARGB(255, 24, 22, 53),),
                ),
              ),
            ],
          ),
        );
      },
      options: CarouselOptions(
        height: 510,
        aspectRatio: 16 / 9,
        viewportFraction: 0.6,
        initialPage: 0,
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
        // onPageChanged: _onCarouselPageChanged,
        scrollDirection: Axis.horizontal,
      ),
    );
  }

  Container builddata2(double width) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 220,
      width: width * width * 0.05,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 251, 252, 252),
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(80.0),
          ),
          border: Border.all(color: Colors.cyan),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 120, 120, 120).withOpacity(0.3),
                offset: new Offset(-8.0, 8.0),
                blurRadius: 20.0,
                spreadRadius: 2.0),
          ],
        ),
        padding: const EdgeInsets.only(
          left: 32,
          top: 20.0,
          bottom: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(
              "จุดเด่นของประกันสัตว์เลี้ยง",
              style: TextStyle(
                  color: Color.fromARGB(255, 5, 9, 73),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Itim"),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              " - ค่ารักษาพยาบาล",
              style: TextStyle(
                  color: Color.fromARGB(255, 14, 13, 13),
                  fontSize: 15,
                  fontFamily: "Itim"),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              " - ค่ารับผิดต่อบุคคลภายนอก",
              style: TextStyle(
                  color: Color.fromARGB(255, 1, 1, 1),
                  fontSize: 15,
                  fontFamily: "Itim"),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              " - ค่าใช้จ่ายการจัดพิธีศพ",
              style: TextStyle(
                  color: Color.fromARGB(255, 3, 3, 3),
                  fontSize: 15,
                  fontFamily: "Itim"),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              " - ค่าวัคซีน",
              style: TextStyle(
                  color: Color.fromARGB(255, 20, 19, 19),
                  fontSize: 15,
                  fontFamily: "Itim"),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              " - ค่าประกาศติดตามสัตว์เลี้ยงสูญหาย",
              style: TextStyle(
                  color: Color.fromARGB(255, 18, 18, 18),
                  fontSize: 15,
                  fontFamily: "Itim"),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              " - ค่าชดเชยกรณีเสียชีวิต",
              style: TextStyle(
                  color: Color.fromARGB(255, 5, 4, 4),
                  fontSize: 15,
                  fontFamily: "Itim"),
            ),
          ],
        ),
      ),
    );
  }

  Container builddata(double width) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 220,
      width: width * width * 0.05,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 251, 252, 252),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(80.0),
          ),
          border: Border.all(color: Colors.cyan),
          boxShadow: [
            BoxShadow(
                color: Color.fromARGB(255, 120, 120, 120).withOpacity(0.3),
                offset: new Offset(-8.0, 8.0),
                blurRadius: 20.0,
                spreadRadius: 1.0),
          ],
        ),
        padding: const EdgeInsets.only(
          left: 32,
          top: 20.0,
          right: 32,
          bottom: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(
              "ทำไมต้องซื้อประกันสัตว์เลี้ยง",
              style: TextStyle(
                  color: Color.fromARGB(255, 5, 9, 73),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Itim"),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              "\t      สัตว์เลี้ยงก็เป็นอีกหนึ่งชีวิตที่สามารถเจ็บป่วยหรือเกิดอุบัติเหตุได้ แต่อย่างที่เรารู้กันดีว่าค่าใช้จ่ายเรื่องค่ารักษาพยาบาลของสุนัขหรือแมวในแต่ละครั้งค่อนข้างสูง ทำให้เจ้าของสัตว์เลี้ยงหลายคนเป็นกังวลในเรื่องค่าใช้จ่าย แต่จะให้เลือกวิธีการที่จะเสียค่าใช้จ่ายน้อยที่สุดเพื่อรักษาและดูแลสัตว์เลี้ยงก็อาจไม่ใช่ทางเลือกที่ดีต่อสุขภาพร่างกายของสัตว์เลี้ยง",
              style: TextStyle(
                  color: Colors.black, fontSize: 15, fontFamily: "Itim"),
            )
          ],
        ),
      ),
    );
  }
}
