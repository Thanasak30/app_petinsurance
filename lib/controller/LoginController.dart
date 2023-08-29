import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constant/constant_value.dart';

class LoginController {
  Future userLogin(String username, String password) async {
    Map data = {
      "username": username,
      "password" : password
    };

    var body = json.encode(data);
     var url = Uri.parse(baseURL + '/login/loginmember');

     http.Response response = await http.post(
      url,
      headers: headers,
      body: body
      );
    return response;
  }
}
