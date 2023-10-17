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

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(""),
          content: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("ชื่อผู้เอาประกันภัย"),
                  Text("${member?.fullname}")
                ],
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
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
          title: Center(child: const Text("หน้าหลัก")),
        ),
        body: Column(
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
        ),
      ),
    );
  }

  CarouselSlider buildcarousel(CarouselController carouselController) {
    return CarouselSlider.builder(
      itemCount: insurancedetail?.length ??
          0, // ให้ itemCount เป็น 0 ถ้า insurancedetail เป็น null
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        final plan = insurancedetail?[itemIndex];
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
              Container(
                decoration: BoxDecoration(
                    color: plan?.insurance_name != null
                        ? Colors.cyan
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(30)),
                child: Center(
                  child: Text(
                    plan?.insurance_name ?? "",
                    style: TextStyle(color: Colors.black, fontSize: 40),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text("${plan?.price ?? ""} บาท", style: TextStyle(fontSize: 18)),
              SizedBox(height: 8),
              Text(
                "ค่ารักษาจากอุบัติเหตุ(บาท)\n ${plan?.medical_expenses ?? ""}",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                "ค่ารักษาจากการเจ็บป่วย(บาท)\n ${plan?.treatment ?? ""}",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 8),
              Text(
                "ค่าวัคซีนป้องกันโรคสัตว์เลี้ยง(บาท)\n ${plan?.cost_of_preventive_vaccination ?? ""}",
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  _showPopup(context);
                },
                child: Text("รายละเอียด"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                onPressed: () {
                  if (petdetail != null) {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return InsuranceREG();
                    }));
                  } else {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return AddPet2();
                    }));
                  }
                },
                child: Text("สมัครแผน"),
              ),
            ],
          ),
        );
      },
      options: CarouselOptions(
        height: 550,
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
      height: 200,
      width: width * width * 0.05,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.cyan,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(80.0),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.cyan.withOpacity(0.3),
                offset: new Offset(-10.0, 10.0),
                blurRadius: 20.0,
                spreadRadius: 4.0),
          ],
        ),
        padding: const EdgeInsets.only(
          left: 32,
          top: 50.0,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(
              "ข้อมมูลทั่วไป",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              "data",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }

  Container builddata(double width) {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      height: 200,
      width: width * width * 0.05,
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.cyan,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(80.0),
          ),
          boxShadow: [
            BoxShadow(
                color: Colors.cyan.withOpacity(0.3),
                offset: new Offset(-10.0, 10.0),
                blurRadius: 20.0,
                spreadRadius: 4.0),
          ],
        ),
        padding: const EdgeInsets.only(
          left: 32,
          top: 50.0,
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Text(
              "ข้อมมูลทั่วไป",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              "data",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
