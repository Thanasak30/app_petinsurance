
import 'dart:io';

import 'package:pet_insurance/model/Petinsuranceregister.dart';

class Payment {

  String? paymentId;
  String? reference_number;
  String? imgpayment;
  double? total;
  String? status;
  Petinsuranceregister? insuranceregister;
  

  Payment({
  this.paymentId,
  this.reference_number,
  this.imgpayment,
  this.total,
  this.status,
  this.insuranceregister,
});

    Map<String, dynamic> fromPaymentToJson() {
    return <String, dynamic>{
      'paymentId': paymentId,
      'reference_number': reference_number,
      'imgpayment': imgpayment,
      'total': total,
      'status' : status,
      'insurance_regId' : insuranceregister?.fromPetregisterToJson(),

    };
  }

    factory Payment.fromJsonToPayment(Map<String, dynamic> json) {
    return Payment(
      paymentId: json["paymentId"].toString(),
      reference_number: json["reference_number"],
      imgpayment: json["reference_number"],
      total: json["total"],
      status: json["status"],
      insuranceregister: Petinsuranceregister.fromJsonToPetregister(json["insurance_regId"])
    );
  }
}

