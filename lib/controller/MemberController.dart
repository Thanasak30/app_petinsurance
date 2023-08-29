import 'dart:convert';

import '../constant/constant_value.dart';
import 'package:http/http.dart' as http;

import '../model/Member.dart';


class MemberController {

  Future addMember(
      String member_name,
      String age,
      String mobileno,
      String member_email,
      String gender,
      String fullname,
      String idcard,
      String address,
      String brithday,
      String password,
      String nationality,
      String id_line,) async {
    Map data = {
      "member_name": member_name,
      "age": age,
      "mobileno": mobileno,
      "member_email": member_email,
      "gender": gender,
      "fullname": fullname,
      "idcard": idcard,
      'address': address,
      'brithday' : brithday,
      'password' : password,
      'nationality' : nationality,
      'id_line' : id_line,
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

    var body = json.encode(data);

    var url = Uri.parse(baseURL + '/member/update');

    http.Response response = await http.put(url, headers: headers, body: body);

    return response;
  }

  Future deleteMember(String memberId) async {
    var url = Uri.parse(baseURL + "/member/delete/" + memberId);

    http.Response response = await http.delete(url);

    return response;
  }

  Future getMemberById(String memberId) async {
    var url = Uri.parse(baseURL + '/member/getbyid/' + memberId);

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


 