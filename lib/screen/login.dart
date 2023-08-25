
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:pet_insurance/screen/View_insurance.dart';
import 'package:pet_insurance/screen/login.dart';
// import '../controller/MemberController.dart';
// import '../widgets/custom_text.dart';
import '../controller/LoginController.dart';
import 'Register.dart';
// import 'Veiw_insurance.dart';
import 'package:http/http.dart' as http;


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool stateResEye = true;
  final LoginController loginController = LoginController();

  TextEditingController userNameTextController = TextEditingController();
  TextEditingController pssswordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            buildImage(size),
            buildappname(),
            buildUser(size),
            buildPassword(size),
            buildbuttom(size),
            buildregister(context),
          ],
        ),
      ),
    );
  }

  Row buildregister(BuildContext context) {
    return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("ยังไม่มีบัญชี ?"),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (BuildContext context) {
                      return RegisterScreen();
                    }));
                  },
                  child: Text("สมัครเข้าใช้งาน"))
            ],
          );
  }

  Row buildbuttom(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            margin: EdgeInsets.symmetric(vertical: 16),
            width: size * 0.6,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                onPressed: ()  {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (BuildContext context) {
                return Viewinsurance();
                }));
              },
                child: Text("เข้าสู่ระบบ"))),
      ],
    );
  }

  Padding buildappname() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Center(
          child: Text(
        "Petinsurance",
        style: TextStyle(fontSize: 20),
      )),
    );
  }

  Padding buildImage(double size) {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: size * 0.5, child: Image.asset('Image/login.png'))
        ],
      ),
    );
  }

  Row buildUser(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: userNameTextController,
            decoration: InputDecoration(
              labelText: "Username",
              prefixIcon: Icon(Icons.account_circle_outlined),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
      ],
    );
  }

  Row buildPassword(double size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(top: 15),
          width: size * 0.6,
          child: TextFormField(
            controller: pssswordController,
            obscureText: stateResEye,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      stateResEye = !stateResEye;
                    });
                  },
                  icon: stateResEye
                      ? Icon(
                          Icons.remove_red_eye,
                          color: Colors.black,
                        )
                      : Icon(
                          Icons.remove_red_eye_outlined,
                          color: Colors.black,
                        )),
              labelText: "Password",
              prefixIcon: Icon(Icons.lock_outline),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(30)),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.cyan),
                  borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ),
      ],
    );
  }
}
