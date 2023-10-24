import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pet_insurance/model/Insurancedetail.dart';
import 'package:pet_insurance/model/Officer.dart';
import 'package:pet_insurance/model/Petinsuranceregister.dart';

import '../constant/constant_value.dart';

class OfficerController {
  Future addPlant(
    String price,
    String accident_or_illness_compensation,
    String cost_of_preventive_vaccination,
    String duration,
    String insurance_name,
    String medical_expenses,
    String pet_funeral_costs,
    String pets_attack_outsiders,
    String third_party_property_values_due_to_pets,
    String treatment,
  ) async {
    Map data = {
      "price": price,
      "accident_or_illness_compensation": accident_or_illness_compensation,
      "price": price,
      "cost_of_preventive_vaccination": cost_of_preventive_vaccination,
      "duration": duration,
      "insurance_name": insurance_name,
      "medical_expenses": medical_expenses,
      "pet_funeral_costs": pet_funeral_costs,
      "pets_attack_outsiders": pets_attack_outsiders,
      "third_party_property_values_due_to_pets":
          third_party_property_values_due_to_pets,
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
    var url =
        Uri.parse(baseURL + '/insurancedetail/getbyid/' + insurance_planId);

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

  dynamic myDateSeriallizer(dynamic object) {
    if (object is DateTime) {
      return object.toIso8601String();
    }
    return object;
  }

  Future getListAllInsurancedetail() async {
    Map data = {};

    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/insurancedetail/insurance_planId');

    http.Response response = await http.post(url, headers: headers, body: body);

    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Insurancedetail> list = jsonResponse
        .map((e) => Insurancedetail.fromJsonToInsurancedetail(e))
        .toList();
    return list;
  }

  Future listInsurance(String memberId) async {
    Map data = {};

    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/insuranceregister/list/' + memberId);

    http.Response response = await http.post(url, headers: headers, body: body);

    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Petinsuranceregister> list = jsonResponse
        .map((e) => Petinsuranceregister.fromJsonToPetregister(e))
        .toList();
    return list;
  }

  Future listInsurancereg() async {
    Map data = {};

    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/insuranceregister/listreg');

    http.Response response = await http.post(url, headers: headers, body: body);

    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Petinsuranceregister> list = jsonResponse
        .map((e) => Petinsuranceregister.fromJsonToPetregister(e))
        .toList();
    return list;
  }

  Future getInsuranceregById(int insurance_regId) async {
    var url = Uri.parse(
        baseURL + '/insuranceregister/getbyid/' + insurance_regId.toString());

    http.Response response = await http.get(url);

    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);

    return jsonResponse;
  }

  Future updateInsurancereg(String office_id,String inusrance_regId) async {

    var url = Uri.parse(baseURL + '/insuranceregister/update/'+ office_id + '/' + inusrance_regId);
    print("URL IS ${url}");
    http.Response response = await http.put(url, headers: headers);

    print("RES CODE IS : ${response.statusCode}");

    return response;
  }


  Future getOfficerByUsername(String username) async {
    var url = Uri.parse(baseURL + '/officer/getbyusername/' + username);

    http.Response response = await http.get(url);

    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);
    return jsonResponse;
  }
}
