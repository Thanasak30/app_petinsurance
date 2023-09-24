 class Insurancedetail {

  String? insurance_planId;
  String? insurance_name;
  String? details;
  String? duration;
  String? medical_expenses;
  String? treatment;
  String? cost_of_preventive_vaccination;
  double? price;


  Insurancedetail({
    this.insurance_planId,
    this.insurance_name,
    this.details,
    this.duration,
    this.medical_expenses,
    this.treatment,
    this.cost_of_preventive_vaccination,
    this.price
  });

    Map<String, dynamic> fromInsurancedetailToJson() {
    return <String, dynamic>{
      'insurance_planId': insurance_planId,
      'insurance_name': insurance_name,
      'details': details,
      'duration': duration,
      'medical_expenses': medical_expenses,
      'treatment': treatment,
      'cost_of_preventive_vaccination': cost_of_preventive_vaccination,
      'price': price,
    };
  }

    factory Insurancedetail.fromJsonToInsurancedetail(Map<String, dynamic> json) {
    return Insurancedetail(
      insurance_planId: json["insurance_planId"],
      insurance_name: json["insurance_name"],
      details: json["details"],
      duration: json["duration"],
      medical_expenses: json["medical_expenses"],
      treatment: json["treatment"],
      cost_of_preventive_vaccination: json["cost_of_preventive_vaccination"],
      price: json["price"],
    );
  }

   
 }