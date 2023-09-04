import "package:pet_insurance/model/Member.dart";

class Petdetail {
  int? petId;
  String? namepet;
  String? agepet;
  String? type;
  String? gender;
  String? listpicture;
  String? species;
  String? animal_species;
  bool? isSick;
  bool? hasGenderDisease;
  String? Checkforinsurance;
  Member? member;

  Petdetail({
    this.petId,
    this.namepet,
    this.agepet,
    this.type,
    this.gender,
    this.listpicture,
    this.species,
    this.animal_species,
    this.isSick,
    this.hasGenderDisease,
    this.Checkforinsurance,
    this.member,
  });

  Map<String, dynamic> fromPetdetailToJson() {
    return <String, dynamic>{
      'petId': petId,
      'namepet': namepet,
      'agepet': agepet,
      'type': type,
      'gender': gender,
      'listpicture': listpicture,
      'species': species,
      'animal_species': animal_species,
      'isSick': isSick,
      'hasGenderDisease': hasGenderDisease,
      'Checkforinsurance': Checkforinsurance,
      'member': member,
    };
  }

  factory Petdetail.fromJsonToPetdetail(Map<String, dynamic> json) {
    return Petdetail(
        petId: json["petId"],
        namepet: json["namepet"],
        agepet: json["agepet"],
        type: json["type"],
        gender: json["gender"],
        listpicture: json["listpicture"],
        species: json["species"],
        animal_species: json["animal_species"],
        hasGenderDisease: json["hasGenderDisease"],
        Checkforinsurance: json["Checkforinsurance"],
        member: json["member"] == null
            ? null
            : Member.fromJsonToMember(json["member_id"]));
  }
}
