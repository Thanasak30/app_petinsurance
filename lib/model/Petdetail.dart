import "package:pet_insurance/model/Member.dart";

class Petdetail{

  String?namepet;
  String?agepet;
  String?type;
  String?gender;
  String?listpicture;
  String?species;
  bool?isSick;
  bool?hasGenderDisease;
  String?Checkforinsurance;
  Member? member;


  Petdetail({
    this.namepet,
    this.agepet,
    this.type,
    this.gender,
    this.listpicture,
    this.species,
    this.isSick,
    this.hasGenderDisease,
    this.Checkforinsurance,
    this.member,
  });


  
    Map<String, dynamic> fromPetdetailToJson() {
    return <String, dynamic>{

      'namepet': namepet,
      'agepet': agepet,
      'type': type,
      'gender': gender,
      'listpicture': listpicture,
      'species': species,
      'isSick': isSick,
      'hasGenderDisease': hasGenderDisease,
      'Checkforinsurance':Checkforinsurance,
      'member' : member,
    };
  }

    factory Petdetail.fromJsonToPetdetail(Map<String, dynamic> json) {
    return Petdetail(

      namepet: json["namepet"],
      agepet: json["agepet"],
      type: json["type"],
      gender: json["gender"],
      listpicture: json["listpicture"],
      species: json["species"],
      hasGenderDisease: json["hasGenderDisease"],
      Checkforinsurance: json["Checkforinsurance"],
      member: Member.fromJsonToMember(json["member_id"])
    );
  }

}