import 'dart:convert';

import 'package:http/http.dart' as http;
import '../constant/constant_value.dart';
import '../model/Petdetail.dart';

class PetdetailController {
  Future addPet(
    String memberId,
    String agepet,
    String gender,
    String namepet,
    String species,
    String type,
    
  ) async {
    Map data = {
      'memberId': memberId,
      "namepet": namepet,
      "agepet": agepet,
      "type": type,
      "gender": gender,
      "species": species,
      
    };

    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + "/petdetail/add");

    http.Response response =
        await http.post(url, headers: headers, body: jsonData);

    print(response.body);
    return response;
  }

  Future updatePetdetail(Petdetail petdetail) async {

    Map<String, dynamic> data = petdetail.fromPetdetailToJson();
    print("DATA FROM CONTROLLER ${data}");
    var body = json.encode(data);
    print(body);

    var url = Uri.parse(baseURL + '/petdetail/update');

    http.Response response = await http.put(url, headers: headers, body: body);


    return response;
  }

  Future updatePetdetailstatus(Petdetail petdetail) async {

    Map<String, dynamic> data = petdetail.fromPetdetailToJson();
    print("DATA FROM CONTROLLER ${data}");
    var body = json.encode(data);
    print(body);

    var url = Uri.parse(baseURL + '/petdetail/updatestatus');

    http.Response response = await http.put(url, headers: headers, body: body);


    return response;
  }

  Future deletePetdetail(String petId) async {
    var url = Uri.parse(baseURL + "/petdetail/delete/" + petId);

    http.Response response = await http.delete(url);

    return response;
  }

  Future getPetdetailById(String petId) async {
    var url = Uri.parse(baseURL + '/petdetail/getbyid/' + petId);

    http.Response response = await http.get(url);

    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);

    return jsonResponse;
  }

  static addPetdetail(String text, String text2, String text3,
      {required String Type,
      required String TypeSpice,
      required String listValue}) {}

  Future listAllPetdetailByMember(String memberId) async {
    Map data = {};

    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/petdetail/list/'+ memberId);

    http.Response response = await http.post(url, headers: headers, body: body);

    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Petdetail> list =
        jsonResponse.map((e) => Petdetail.fromJsonToPetdetail(e)).toList();
    return list;
  }

  Future listShowPetdetailByMember(String memberId) async {
    Map data = {};

    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/petdetail/listshow/'+ memberId);

    http.Response response = await http.post(url, headers: headers, body: body);

    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Petdetail> list =
        jsonResponse.map((e) => Petdetail.fromJsonToPetdetail(e)).toList();
    return list;
  }

   Future listAllpayment() async {
    Map data = {};

    var body = json.encode(data);
    var url = Uri.parse(baseURL + '/petdetail/list');

    http.Response response = await http.post(url, headers: headers, body: body);

    final utf8Body = utf8.decode(response.bodyBytes);
    List<dynamic> jsonResponse = json.decode(utf8Body);
    List<Petdetail> list = jsonResponse
        .map((e) => Petdetail.fromJsonToPetdetail(e))
        .toList();
    return list;
  }
}
