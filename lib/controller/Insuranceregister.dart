import 'dart:convert';
import 'dart:io';

import 'package:http_parser/http_parser.dart';
import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;

class InsuranceREG {
  Future addInsuranceReg(

    String insurance_planId,
    String memberId,
    String receivedByEmail,
    String startdate,
    String enddate,
    String status,
    File vaccine_documents,
    File ImgPet,
    File health_certificate,
    String pet_id
  ) async {
    var data = {
      "memberId": memberId,
      "receivedByEmail": receivedByEmail,
      "startdate": startdate,
      "enddate" : enddate,
      "status": status,
      "insurance_planId": insurance_planId,
      "pet_id" : pet_id

   
    };
    // อัปโหลดไฟล์และรับพาธของไฟล์
    var pathVaccine = await uploadImages(vaccine_documents);
    var pathImgPet = await uploadImages(ImgPet);
    var pathHealthCertificate = await uploadImages(health_certificate);

    // เพิ่มพาธของไฟล์ลงในข้อมูล
    data["vaccine_documents"] = pathVaccine;
    data["ImgPet"] = pathImgPet;
    data["health_certificate"] = pathHealthCertificate;

    // แปลงข้อมูลเป็น JSON
    var jsonData = json.encode(data);

    // ส่งข้อมูลไปยังเซิร์ฟเวอร์
    var url = Uri.parse(baseURL + "/insuranceregister/add");
    var response = await http.post(url, headers: headers, body: jsonData);

    print(response.body);
    return response;
  }

  Future<String> uploadImages(File? image) async {
    // ตรวจสอบว่า image ไม่เป็น null ก่อนใช้
    if (image != null) {
      var uri = Uri.parse(baseURL + "/insuranceregister/upload");

      var request = http.MultipartRequest('POST', uri);
      var stream = http.ByteStream(image.openRead());
      var length = await image.length();
      var multipartFile = http.MultipartFile(
        'images',
        stream,
        length,
        filename: image.path.split('/').last,
        contentType: MediaType('image', 'png'),
      );
      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        var jsonResponse = await response.stream.bytesToString();
        return jsonResponse; // รีเทิร์น URL ของไฟล์ภาพที่ถูกอัปโหลด
      } else {
        throw Exception('Failed to upload image');
      }
    } else {
      throw Exception('Image file is null');
    }
  }
}
