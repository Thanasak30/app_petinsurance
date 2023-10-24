import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../constant/constant_value.dart';

class PaymentController {
  Future addimgPayment(
    String insurance_regId,
    String total,
    String reference_number,
    File imgpayment,
  
  ) async {
    var data = {
      "imgpayment" : imgpayment,
      "insurance_regId": insurance_regId,
      "total": total,
      "reference_number": reference_number,
    };
    // อัปโหลดไฟล์และรับพาธของไฟล์
    var pathimgpayment = await uploadImages(imgpayment);

    data["imgpayment"] = pathimgpayment;

    // แปลงข้อมูลเป็น JSON
    var jsonData = json.encode(data);

    // ส่งข้อมูลไปยังเซิร์ฟเวอร์
    var url = Uri.parse(baseURL + "/payment/add");
    var response = await http.post(url, headers: headers, body: jsonData);

    print(response.body);
    return response;
  }

  Future<String> uploadImages(File? image) async {
    // ตรวจสอบว่า image ไม่เป็น null ก่อนใช้
    if (image != null) {
      var uri = Uri.parse(baseURL + "/payment/upload");

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

  Future getReferentById(String? insurance_regId) async {
    var url = Uri.parse(baseURL + '/payment/getbyinsid/' + insurance_regId.toString());

    http.Response response = await http.get(url);

    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);

    return jsonResponse;
  }
}
