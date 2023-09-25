 class Insurancedetail {

  int? insurance_planId;
  String? insurance_name;
  String? duration;
  String? medical_expenses;
  String? treatment;
  String? cost_of_preventive_vaccination;
  double? price;


  Insurancedetail({
    this.insurance_planId,
    this.price,
    this.cost_of_preventive_vaccination,
    this.duration,
    this.insurance_name,
    this.medical_expenses,
    this.treatment,
    
    
  });

    Map<String, dynamic> fromInsurancedetailToJson() {
    return <String, dynamic>{
      'insurance_planId': insurance_planId,
      'price': price,
      'cost_of_preventive_vaccination': cost_of_preventive_vaccination,
      'duration': duration,
      'insurance_name': insurance_name,
      'medical_expenses': medical_expenses,
      'treatment': treatment,
      
      
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
    );
  }

   
 }