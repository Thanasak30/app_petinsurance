 class Insurancedetail {

  String? insurance_planId;
  String? insurance_name;
  String? details;
  String? duration;
  String? medical_expenses;
  String? treatment;
  String? medical_expenses_pertime;
  double? price;


  Insurancedetail({
    this.insurance_planId,
    this.insurance_name,
    this.details,
    this.duration,
    this.medical_expenses,
    this.treatment,
    this.medical_expenses_pertime,
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
      'medical_expenses_pertime': medical_expenses_pertime,
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
      medical_expenses_pertime: json["medical_expenses_pertime"],
      price: json["price"],
    );
  }

   
 }