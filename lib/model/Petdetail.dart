import "package:pet_insurance/model/Member.dart";

class Petdetail {
  int? petId;
  String? agepet;
  String? gender;
  String? namepet;
  String? species;
  String? type;
  String? status;
  Member? member;

  Petdetail({
    this.petId,
    this.agepet,
    this.gender,
    this.namepet,
    this.species,
    this.type,
    this.status,
    this.member,
  });

  Map<String, dynamic> fromPetdetailToJson() {
    return <String, dynamic>{
      'petId': petId,
      'agepet': agepet,
      'gender': gender,
      'namepet': namepet,
      'species': species,
      'type': type,
      'Status' : status,
      'members': member?.fromMemberToJson(),
    };
  }

  factory Petdetail.fromJsonToPetdetail(Map<String, dynamic> json) {
    return Petdetail(

        petId: json["petId"],
        agepet: json["agepet"],
        gender: json["gender"],
        namepet: json["namepet"],
        species: json["species"],
        type: json["type"],
        status: json["status"],
        member: Member.fromJsonToMember(json["members"]));
  }
}
