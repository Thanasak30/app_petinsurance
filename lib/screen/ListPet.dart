import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:pet_insurance/controller/MemberController.dart';
import 'package:pet_insurance/screen/EditPet.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:http/http.dart' as http;
import '../controller/PetdetailController.dart';
import '../model/Member.dart';
import '../model/Petdetail.dart';
import 'View_insurance.dart';

class ListPet extends StatefulWidget {
  const ListPet({super.key});

  @override
  State<ListPet> createState() => _ListPetState();
}

class _ListPetState extends State<ListPet> {
  final PetdetailController petdetailController = PetdetailController();
  final MemberController memberController = MemberController();

  List<Petdetail>? petdetail;
  String? user;
  bool? isLoaded;
  Member? member;

  bool? isLoade;
  void fetcData() async {
    user = await SessionManager().get("username");
    print(user);
    member = await memberController.getMemberById(user!);
    petdetail = await petdetailController
        .listAllPetdetailByMember(member!.memberId.toString());
    print(petdetail);
    setState(() {
      isLoade = true;
    });
  }

  @override
  void initState() {
    super.initState();
    fetcData();
  }

  void showSureToDeletePetAlert(String petId) {
    QuickAlert.show(
        context: context,
        title: "คุณแน่ใจหรือไม่ ? ",
        text: "คุณต้องการลบข้อมูลสมาชิกหรือไม่ ? ",
        type: QuickAlertType.warning,
        confirmBtnText: "ลบ",
        onConfirmBtnTap: () async {
          http.Response response =
              await petdetailController.deletePetdetail(petId);

          if (response.statusCode == 200) {
            Navigator.pop(context);
            showUpDeletePetSuccessAlert();
          } else {
            showFailToDeletePetAlert();
          }
        },
        cancelBtnText: "ยกเลิก",
        showCancelBtn: true);
  }

  void showFailToDeletePetAlert() {
    QuickAlert.show(
        context: context,
        title: "เกิดข้อผิดพลาด",
        text: "ไม่สามารถลบข้อมูลสมาชิกได้",
        type: QuickAlertType.error);
  }

  void showUpDeletePetSuccessAlert() {
    QuickAlert.show(
        context: context,
        title: "สำเร็จ",
        text: "ลบข้อมูลสำเร็จ",
        type: QuickAlertType.success,
        confirmBtnText: "ตกลง",
        onConfirmBtnTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ListPet()));
        });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          "รายการสัตว์เลี้ยง",
          style: TextStyle(fontFamily: "Itim"),
        ),
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (BuildContext context) {
              return Viewinsurance();
            }));
          },
        ),
      ),
      body:isLoade == true? ListView.builder(
          itemCount: petdetail?.length,
          itemBuilder: (context, index) {
            return Padding(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
              child: Card(
                  elevation: 10,
                  child: ListTile(
                    leading: _buildPetImage(petdetail?[index].type),
                    title: Text(
                      "${petdetail?[index].namepet}",
                      style: TextStyle(fontFamily: "Itim"),
                    ),
                    onTap: () {
                      print("pet_id ${petdetail?[index].petId}");
                      print("member_Id ${member?.memberId.toString()}");
                      print("Click at ${index}");
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (_) => EditPet(
                          pet_id: (petdetail?[index].petId).toString(),
                          member_Id: (member!.memberId.toString()),
                        ),
                      ));
                    },
                    trailing: GestureDetector(
                      onTap: () {
                        if (petdetail?[index].status ==
                            "ยังไม่ได้ทำการสมัครแผน") {
                          showSureToDeletePetAlert(
                              petdetail?[index].petId.toString() ?? "");
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              'ไม่สามารถลบสัตว์เลี้ยงได้!',
                              style: TextStyle(
                                  fontFamily: "Itim", color: Colors.white),
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.delete,
                      ),
                    ),
                  )),
            );
          }):Center(child: CircularProgressIndicator()),
    ));
  }

  Widget _buildPetImage(String? petType) {
    String imagePath =
        'Image/pet.png'; // รูปภาพเริ่มต้นสำหรับสัตว์เลี้ยงประเภทอื่น ๆ

    if (petType == 'สุนัข') {
      imagePath = 'Image/dog.png'; // รูปภาพสำหรับสุนัข
    }

    return Image.asset(
      imagePath,
      width: 30, // กำหนดขนาดความกว้างของรูปภาพ
      height: 50, // กำหนดขนาดความสูงของรูปภาพ
      color: Colors.black, // ตั้งค่าสีพื้นหลัง
    );
  }
}
