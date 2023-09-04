import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:pet_insurance/screen/AddPet.dart';
import 'package:pet_insurance/screen/insurance_reg1.dart';

import '../navbar/navbar.dart';

class Viewinsurance extends StatefulWidget {
  const Viewinsurance({super.key});

  @override
  State<Viewinsurance> createState() => _ViewinsuranceState();
}

class _ViewinsuranceState extends State<Viewinsurance> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    CarouselController carouselController = CarouselController();

    return Scaffold(
      drawer: Navbar(),
      appBar: AppBar(
        title: Center(child: const Text("หน้าหลัก")),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          builddata(width),
          builddata2(width),
          const SizedBox(
            height: 20,
          ),
          buildcarousel(carouselController),
          const SizedBox(
            height: 20,
          ),
          buildbutton(carouselController),
        ],
      )),
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
                      return AddPet();
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
