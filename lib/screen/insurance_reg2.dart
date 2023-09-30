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
          buildcarousel(carouselController),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  

  CarouselSlider buildcarousel(CarouselController carouselController) {
    return CarouselSlider.builder(
      itemCount: insurancedetail?.length,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
        final plan = insurancedetail?[itemIndex];
        return Container(
          width: double.infinity,
          color: Color.fromARGB(255, 176, 173, 173).withOpacity(1),
          child: Center(
            child: Column(
              children: [
                Text(
                  plan!.insurance_name.toString(),
                  style: TextStyle(color: Colors.black, fontSize: 40),
                ),
                Text("${plan.price.toString()}" + "บาท"),
                Text("ค่ารักษาจากอุบัติเหตุ(บาท)\n ${plan.medical_expenses}" +
                    "บาท/ครั้ง\t" +
                    "ครั้ง/ปี"),
                Text("ค่ารักษาจากการเจ็บป่วย(บาท)\n ${plan.treatment}\t" +
                    "บาท/ครั้ง\t" +
                    "ครั้ง/ปี"),
                Text("ค่าวัคซีนป้องกันโรคสัตว์เลี้ยง(บาท)\n" +
                    "${plan.cost_of_preventive_vaccination}"),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => InsuranceREG4(
                            pet_id: (petdetail?.petId).toString(),
                            insurance_planId:
                                (insurancedetails?.insurance_planId).toString(),
                          ),
                        ),
                      );
                    },
                    child: Text("สมัครแผน"))
              ],
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 300,
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
