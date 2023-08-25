

class Login {
  String? username;
  String? password;
  String? usertype;

  Login({
    this.username,
    this.password,
    this.usertype
  });

  Map<String, dynamic> fromLoginToJson() {
    return <String, dynamic>{
      'username': username,
      'password': password,
      'usertype': usertype,
    };
  }

    factory Login.fromJsonToLogin(Map<String, dynamic> json) {
    return Login(
      username: json["username"],
      password: json["password"],
      usertype: json["usertype"],
    );
  }
  
}