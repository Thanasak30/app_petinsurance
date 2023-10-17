import 'dart:convert';

import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;

import '../model/Member.dart';

class MemberController {
  Future addMember(
    String brithday,
    String address,
    String age,
    String fullname,
    String gender,
    String id_line,
    String idcard,
    String member_email,
    String mobileno,
    String nationality,
    String password,
    String username
  ) async {
    Map data = {
      "age": age,
      "mobileno": mobileno,
      "member_email": member_email,
      "gender": gender,
      "fullname": fullname,
      "idcard": idcard,
      'address': address,
      'brithday': brithday,
      'password': password,
      'nationality': nationality,
      'id_line': id_line,
      'username' : username
    };
    var jsonData = json.encode(data);
    var url = Uri.parse(baseURL + "/member/add");
    http.Response response =
        await http.post(url, headers: headers, body: jsonData);

    print(response.body);
    return response;
  }

  Future updateMember(Member member) async {
    Map<String, dynamic> data = member.fromMemberToJson();

    var body = json.encode(data, toEncodable: myDateSeriallizer);
    var url = Uri.parse(baseURL + '/member/update');

    http.Response response = await http.put(url, headers: headers, body: body);

    return response;
  }
  dynamic myDateSeriallizer(dynamic object){
    if(object is DateTime){
      return object.toIso8601String();
    }
    return object;

  }

  Future deleteMember(String memberId) async {
    var url = Uri.parse(baseURL + "/member/delete/" + memberId);

    http.Response response = await http.delete(url);

    return response;
  }

  Future getMemberById(String username) async {
    var url = Uri.parse(baseURL + '/member/getbyid/' + username);

    http.Response response = await http.get(url);

    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);
    Member member = Member.fromJsonToMember(jsonResponse);
    return member;
  }

  Future getMemberByUsername(String username) async {
    var url = Uri.parse(baseURL + '/member/getbyusername/' + username);

    http.Response response = await http.get(url);

    final utf8Body = utf8.decode(response.bodyBytes);
    var jsonResponse = json.decode(utf8Body);
    return jsonResponse;
  }
}
