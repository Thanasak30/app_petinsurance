import 'package:pet_insurance/model/Insurancedetail.dart';
import 'package:pet_insurance/model/Officer.dart';

import 'Member.dart';

class Petinsuranceregister {
  String? insurance_regId;
  String? date;
  bool? receivedByEmail;
  String? id_line;
  String? vaccine_documents;
  Member? member;
  Officer? officer;
  Insurancedetail? insurancedetail;

  Petinsuranceregister({
    this.insurance_regId,
    this.date,
    this.receivedByEmail,
    this.id_line,
    this.vaccine_documents,
    this.member,
    this.officer,
    this.insurancedetail
  });

    Map<String, dynamic> fromPetregisterToJson() {
    return <String, dynamic>{
      'insurance_regId': insurance_regId,
      'date': date,
      'receivedByEmail': receivedByEmail,
      'id_line': id_line,
      'vaccine_documents': vaccine_documents,
      'member': member,
      'officer': officer,
      'insurancedetail': insurancedetail,
    };
  }

  factory Petinsuranceregister.fromJsonToPetregister(Map<String, dynamic> json) {
    return Petinsuranceregister(
      insurance_regId: json["insurance_regId"],
      date: json["date"],
      receivedByEmail: json["receivedByEmail"],
      id_line: json["id_line"],
      vaccine_documents: json["vaccine_documents"],
      member: Member.fromJsonToMember(json["member_id"]),
      officer: Officer.fromJsonToOfficer(json["officer_id"]),
      insurancedetail: Insurancedetail.fromJsonToInsurancedetail(json["insurance_plan_id"])
    );
  }
}
