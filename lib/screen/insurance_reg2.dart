import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pet_insurance/model/Petdetail.dart';
import 'package:pet_insurance/screen/insurance_reg1.dart';
import 'package:pet_insurance/screen/insurance_reg3.dart';
import 'package:pet_insurance/screen/insurance_reg4.dart';

import '../controller/OfficerController.dart';
import '../controller/PetdetailController.dart';
import '../model/Insurancedetail.dart';
import 'AddPet.dart';

class InsuranceREG2 extends StatefulWidget {
  final String pet_id;
  const InsuranceREG2({Key? key, required this.pet_id}) : super(key: key);

  @override
  State<InsuranceREG2> createState() => _InsuranceREG2State();
}

class _InsuranceREG2State extends State<InsuranceREG2> {
  final petdetailController = PetdetailController();

  Petdetail? petdetail;
  bool? isLoade;

  List<Insurancedetail>? insurancedetail;
  Insurancedetail? insurancedetails;

  OfficerController officerController = OfficerController();

  void fetcData(String pet_id) async {
    setState(() {
      isLoade = false;
    });
    var response = await petdetailController.getPetdetailById(pet_id);
    petdetail = Petdetail.fromJsonToPetdetail(response);
    insurancedetail = await officerController.listAllInsurance();
    setState(
      () {
        isLoade = true;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetcData(widget.pet_id);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    CarouselController carouselController = CarouselController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("สมัครแผนประกัน"),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return InsuranceREG();
            }));
          },
        ),
      ),
      body: ListView(
        children: [
          buildappname(),
          builddatapet(),
          buildshowdatapet(),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            height: 500, // กำหนดความสูงของ Carousel ตามต้องการ
            child: buildcarousel(carouselController),
          ),
        ],
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
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (BuildContext context) {
                    return InsuranceREG();
                  }));
                },
                child: Text("รายละเอียด"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                onPressed: () {
                 Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (_) => InsuranceREG4(
                              pet_id: (petdetail?.petId).toString(), insurance_planId: (plan?.insurance_planId).toString(),)));
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

  Row buildshowdatapet() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text("${petdetail?.namepet}"),
        Text("${petdetail?.animal_species}"),
        Text("${petdetail?.agepet}")
      ],
    );
  }

  Row builddatapet() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [Text("สัตว์เลี้ยง :"), Text("สายพันธุ์ :"), Text("อายุ :")],
    );
  }

  Center buildappname() {
    return Center(
      child: Text(
        "แผนประกันสำหรับสัตว์เลี้ยง",
        style: TextStyle(fontSize: 20),
      ),
    );
  }
}
