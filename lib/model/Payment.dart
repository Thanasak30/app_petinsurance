

import 'package:pet_insurance/model/Petinsuranceregister.dart';

class Payment {

  String?paymentId;
  String?reference_number;
  String?policy_number;
  double?total;
  Petinsuranceregister? insuranceregister;
  

  Payment({
  this.paymentId,
  this.reference_number,
  this.policy_number,
  this.total,
  this.insuranceregister,
});

    Map<String, dynamic> fromPaymentToJson() {
    return <String, dynamic>{
      'paymentId': paymentId,
      'reference_number': reference_number,
      'policy_number': policy_number,
      'total': total,
      'insuranceregister' : insuranceregister,

    };
  }

    factory Payment.fromJsonToPayment(Map<String, dynamic> json) {
    return Payment(
      paymentId: json["paymentId"],
      reference_number: json["reference_number"],
      policy_number: json["policy_number"],
      total: json["total"],
      insuranceregister: Petinsuranceregister.fromJsonToPetregister(json["insurance_reg_id"])
    );
  }
}

