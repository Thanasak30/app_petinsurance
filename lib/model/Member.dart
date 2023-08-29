import 'package:pet_insurance/model/Login.dart';



class Member {

  int? memberId;
  String? member_name;
  String? age;
  String? mobileno;
  String? member_email;
  String? gender;
  String? fullname;
  String? idcard;
  String? address;
  DateTime? brithday;
  String? nationality;
  String? id_line;
  Login? login;

  Member({
    this.memberId,
    this.member_name,
    this.age,
    this.mobileno,
    this.member_email,
    this.gender,
    this.fullname,
    this.idcard,
    this.address,
    this.brithday,
    this.nationality,
    this.id_line,
    this.login
  });


    Map<String, dynamic> fromMemberToJson() {
    return <String, dynamic>{
      'memberId': memberId,
      'member_name': member_name,
      'age': age,
      'mobileno': mobileno,
      'member_email': member_email,
      'gender': gender,
      'fullname': fullname,
      'idcard': idcard,
      'address': address,
      'brithday': brithday?.toIso8601String(),
      'nationality' : nationality,
      'id_line' : id_line,
      'login': login?.fromLoginToJson()
    };
  }

    factory Member.fromJsonToMember(Map<String, dynamic> json) {
    return Member(
      memberId: json["memberId"],
      member_name: json["member_name"],
      age: json["age"],
      mobileno: json["mobileno"],
      member_email: json["member_email"],
      gender: json["gender"],
      fullname: json["fullname"],
      idcard: json["idcard"],
      address: json["address"],
      brithday: DateTime.parse(json["brithday"]),
      nationality: json["nationality"],
      id_line: json["id_line"],
      login: Login.fromJsonToLogin(json["username"])
    );
  }
  
}