import 'package:pet_insurance/model/Insurancedetail.dart';
import 'package:pet_insurance/model/Officer.dart';

import 'Member.dart';
import 'Petdetail.dart';

class Petinsuranceregister {
  int? insurance_regId;
  DateTime? startdate;
  DateTime? enddate;
  bool? receivedByEmail;
  String? vaccine_documents;
  Member? member;
  Officer? officer;
  Insurancedetail? insurancedetail;
  String? health_certificate;
  String? ImgPet;
  String? status;
  Petdetail? petdetail;

  Petinsuranceregister(
      {this.insurance_regId,
      this.startdate,
      this.enddate,
      this.receivedByEmail,
      this.vaccine_documents,
      this.member,
      this.officer,
      this.insurancedetail,
      this.health_certificate,
      this.ImgPet,
      this.status,
      this.petdetail});

  Map<String, dynamic> fromPetregisterToJson() {
    return <String, dynamic>{
      'insurance_regId': insurance_regId,
      'startdate': startdate,
      'enddate' : enddate,
      'receivedByEmail': receivedByEmail,
      'vaccine_documents': vaccine_documents,
      'member': member,
      'officer': officer,
      'insurancedetail': insurancedetail,
      'health_certificate': health_certificate,
      'ImgPet': ImgPet,
      'status': status,
      'petdetail': petdetail
    };
  }

  factory Petinsuranceregister.fromJsonToPetregister(
      Map<String, dynamic> json) {
    return Petinsuranceregister(
        insurance_regId: json["insurance_regId"],
        startdate: DateTime.parse(json["startdate"]).toLocal(),
        enddate: DateTime.parse(json["enddate"]).toLocal(),
        receivedByEmail: json["receivedByEmail"],
        vaccine_documents: json["vaccine_documents"],
        member: Member.fromJsonToMember(json["memberId"]),
        officer: json["officerId"] == null
            ? null
            : Officer.fromJsonToOfficer(json["officerId"]),
        insurancedetail:
            Insurancedetail.fromJsonToInsurancedetail(json["insurance_planId"]),
        health_certificate: json["health_certificate"],
        ImgPet: json["ImgPet"],
        status: json["status"],
        petdetail: Petdetail.fromJsonToPetdetail(json["petid"]));
  }
}
