import "package:pet_insurance/model/Member.dart";

class Petdetail {
  bool? hasGenderDisease;
  bool? isSick;
  int? petId;
  String? agepet;
  String? animal_species;
  String? Checkforinsurance;
  String? gender;
  String? listpicture;
  String? namepet;
  String? species;
  String? type;
  Member? member;

  Petdetail({
    this.hasGenderDisease,
    this.isSick,
    this.petId,
    this.agepet,
    this.animal_species,
    this.Checkforinsurance,
    this.gender,
    this.listpicture,
    this.namepet,
    this.species,
    this.type,
    this.member,
  });

  Map<String, dynamic> fromPetdetailToJson() {
    return <String, dynamic>{
      'hasGenderDisease': hasGenderDisease,
      'isSick': isSick,
      'petId': petId,
      'agepet': agepet,
      'animal_species': animal_species,
      'Checkforinsurance': Checkforinsurance,
      'gender': gender,
      'listpicture': listpicture,
      'namepet': namepet,
      'species': species,
      'type': type,
      'member': member?.fromMemberToJson(),
    };
  }

  factory Petdetail.fromJsonToPetdetail(Map<String, dynamic> json) {
    return Petdetail(
        hasGenderDisease: json["hasGenderDisease"],
        isSick: json["isSick"],
        petId: json["petId"],
        agepet: json["agepet"],
        animal_species: json["animal_species"],
        Checkforinsurance: json["Checkforinsurance"],
        gender: json["gender"],
        listpicture: json["listpicture"],
        namepet: json["namepet"],
        species: json["species"],
        type: json["type"],
        member: json["member"] == null
            ? null
            : Member.fromJsonToMember(json["member_id"]));
  }
}
