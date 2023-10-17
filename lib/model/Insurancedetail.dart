import 'package:pet_insurance/model/Member.dart';
import 'package:pet_insurance/model/Officer.dart';
import 'package:pet_insurance/model/Petinsuranceregister.dart';

import 'Petdetail.dart';

class Insurancedetail {

  int? insurance_planId;
  String? insurance_name;
  String? duration;
  String? medical_expenses;
  String? treatment;
  String? cost_of_preventive_vaccination;
  String? pet_funeral_costs;
  String? pets_attack_outsiders;
  String? third_party_property_values_due_to_pets;
  String? accident_or_illness_compensation;
  double? price;
  Member? member;
  Officer? officer;
  // Petdetail? petdetail;
  Petinsuranceregister? petinsuranceregister;

  Insurancedetail({
    this.insurance_planId,
    this.price,
    this.cost_of_preventive_vaccination,
    this.duration,
    this.insurance_name,
    this.medical_expenses,
    this.pet_funeral_costs,
    this.pets_attack_outsiders,
    this.third_party_property_values_due_to_pets,
    this.accident_or_illness_compensation,
    this.treatment,

  }
  );

  Map<String, dynamic> fromInsurancedetailToJson() {
    return <String, dynamic>{
      'insurance_planId': insurance_planId,
      'price': price,
      'cost_of_preventive_vaccination': cost_of_preventive_vaccination,
      'duration': duration,
      'insurance_name': insurance_name,
      'medical_expenses': medical_expenses,
      'treatment': treatment,
      'pet_funeral_costs': pet_funeral_costs,
      'pets_attack_outsiders': pets_attack_outsiders,
      'third_party_property_values_due_to_pets': third_party_property_values_due_to_pets,
      'accident_or_illness_compensation': accident_or_illness_compensation,

      
    };
  }

  factory Insurancedetail.fromJsonToInsurancedetail(Map<String, dynamic> json) {
    return Insurancedetail(
      insurance_planId: json["insurance_planId"],
      price: json["price"],
      cost_of_preventive_vaccination: json["cost_of_preventive_vaccination"],
      duration: json["duration"],
      insurance_name: json["insurance_name"],
      medical_expenses: json["medical_expenses"],
      treatment: json["treatment"],
      pet_funeral_costs: json["pet_funeral_costs"],
      pets_attack_outsiders: json["pets_attack_outsiders"],
      third_party_property_values_due_to_pets: json["third_party_property_values_due_to_pets"],
      accident_or_illness_compensation: json["accident_or_illness_compensation"],
    );
  }
  
   
 }