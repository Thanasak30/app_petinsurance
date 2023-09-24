import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constant/constant_value.dart';

class OfficerController {
  Future addPlant(
    String price,
    String cost_of_preventive_vaccination,
    String details,
    String duration,
    String insurance_name,
    String medical_expenses,
    String treatment,
  ) async {
    Map data = {
      "price": price,
      "cost_of_preventive_vaccination": cost_of_preventive_vaccination,
      "details": details,
      "duration": duration,
      "insurance_name": insurance_name,
      "medical_expenses": medical_expenses,
      "treatment": treatment,
    };

    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + "/insurancedetail/add");

    http.Response response =
        await http.post(url, headers: headers, body: jsonData);

    print(response.body);
    return response;
  }
}
