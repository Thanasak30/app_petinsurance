import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pet_insurance/screen/insurance_reg3.dart';

import 'AddPet.dart';

class InsuranceREG2 extends StatefulWidget {
  const InsuranceREG2({super.key});

  @override
  State<InsuranceREG2> createState() => _InsuranceREG2State();
}

class _InsuranceREG2State extends State<InsuranceREG2> {
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
          onPressed: () {},
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
          buildbutton(carouselController),
        ],
      ),
    );
  }

  Center buildbutton(CarouselController carouselController) {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
            onPressed: () {
              carouselController.previousPage();
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.cyanAccent,
            ),
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                primary: Colors.redAccent),
          ),
          SizedBox(
            width: 20,
          ),
          ElevatedButton(
            onPressed: () {
              carouselController.nextPage();
            },
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.cyanAccent,
            ),
            style: ElevatedButton.styleFrom(
                shape: CircleBorder(),
                padding: EdgeInsets.all(20),
                primary: Colors.redAccent),
          ),
        ],
      ),
    );
  }

  CarouselSlider buildcarousel(CarouselController carouselController) {
    return CarouselSlider.builder(
      carouselController: carouselController,
      itemCount: 3,
      itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
          Container(
        width: double.infinity,
        color: Color.fromARGB(255, 176, 173, 173).withOpacity(1),
        child: Center(
          child: Column(
            children: [
              Text(
                " แผน ${(itemIndex + 1).toString()}",
                style: TextStyle(color: Colors.black, fontSize: 40),
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return InsuranceREG3();
                    }));
                  },
                  child: Text("สมัครแผน"))
            ],
          ),
        ),
      ),
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
      children: [Text("สัตว์เลี้ยง :"), Text("สายพันธุ์ :"), Text("อายุ :")],
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
