

import 'package:pet_insurance/model/Login.dart';

class Officer {

  String? OfficerId;
  String? officername;
  Login? username;

  Officer({
    this.OfficerId,
    this.officername,
    this.username,
  });

   Map<String, dynamic> fromOfficerToJson(json) {
    return <String, dynamic>{
      'OfficerId': OfficerId,
      'officername': officername,
      'username' : username?.fromLoginToJson()
    };
  }

    factory Officer.fromJsonToOfficer(Map<String, dynamic> json) {
    return Officer(
      OfficerId: json["officerId"],
      officername: json["officername"],
      username :Login.fromJsonToLogin(json["username"])
    );
  }
  
}