import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pet_insurance/model/Insurancedetail.dart';
import 'package:pet_insurance/model/Officer.dart';

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

  Future listAllInsurance() async {
    Map data = {};

    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/insurancedetail/list');

    http.Response response = await http.post(url, headers: headers, body: body);

    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Insurancedetail> list = jsonResponse
        .map((e) => Insurancedetail.fromJsonToInsurancedetail(e))
        .toList();
    return list;
  }

  Future getInsuranceById(String insurance_planId) async {
    var url = Uri.parse(baseURL + '/insurancedetail/getbyid/' + insurance_planId);

    http.Response response = await http.get(url);

    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);

    return jsonResponse;
  }

  Future updateInsurancedetail(Insurancedetail insurancedetail) async {
    Map<String, dynamic> data = insurancedetail.fromInsurancedetailToJson();

    var body = json.encode(data, toEncodable: myDateSeriallizer);
    var url = Uri.parse(baseURL + '/insurancedetail/update');

    http.Response response = await http.put(url, headers: headers, body: body);

    return response;
  }
  dynamic myDateSeriallizer(dynamic object){
    if(object is DateTime){
      return object.toIso8601String();
    }
    return object;

  }
}
