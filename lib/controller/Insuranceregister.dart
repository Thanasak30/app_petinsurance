import 'dart:convert';
import 'dart:io';

import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;

class InsuranceREG {
  Future addInsuranceReg(
    String insurance_planId,
    String memberId,
    String receivedByEmail,
    String date,
    String officer_id,
    String status,
    File vaccine_documents,
  ) async {
    Map data = {
      // "insurance_planId": "3",
      // // "memberId": "1",
      // "receivedByEmail": "5",
      // "Status": "2",
      "officer_id": "OF001",
      // "insurance_regId": "203",
      // "insurance_plan_id": insurance_plan_id,
      "memberId": memberId,
      "receivedByEmail": receivedByEmail,
      "date": date,
      "Status": status,
      // "officer_id": officer_id,
      "insurance_planId": insurance_planId,
      "vaccine_documents": vaccine_documents,
    };
    var path = await upload(vaccine_documents);
    print("testpath ${path}");

    data["vaccine_documents"] = path;

    print("testdata ${data}");

    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + "/insuranceregister/add");
    http.Response response =
        await http.post(url, headers: headers, body: jsonData);

    print(response.body);
    return response;
  }

  Future upload(File file) async {
    if (file == null) return;

    var uri = Uri.parse(baseURL + "/insuranceregister/upload");
    var length = await file.length();
    //print(length);
    http.MultipartRequest request = new http.MultipartRequest('POST', uri)
      ..headers.addAll(headers)
      ..files.add(
        // replace file with your field name exampe: image
        http.MultipartFile('image', file.openRead(), length,
            filename: 'test.png'),
      );
    var response = await http.Response.fromStream(await request.send());
    //var jsonResponse = jsonDecode(response.body);
    print("test ${response.body}");
    return response.body;
  }
}
