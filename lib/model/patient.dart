import 'package:json_annotation/json_annotation.dart';
import 'package:dr_tooth/model/payment.dart';
import 'package:dr_tooth/model/treatment.dart';

part 'patient.g.dart';

@JsonSerializable()
class Patient {
  final String id;
  final String name;
  final String gender;
  final int age;
  final String phoneNumber;
  int debts;
  final List<Treatment> treatments;
  final List<Payment> payments;

  Patient({
    required this.id,
    required this.name,
    required this.gender,
    required this.age,
    required this.debts,
    required this.phoneNumber,
    required this.treatments,
    required this.payments,
  }) {
    debts = ((treatments.isEmpty) ? 0 : treatments.map((e) => e.cost).reduce((v, e) => v + e)) - ((payments.isEmpty) ? 0 : payments.map((e) => e.amount).reduce((v, e) => v + e));
  }

  factory Patient.fromJson(Map<String, dynamic> json) => _$PatientFromJson(json);
  Map<String, dynamic> toJson() => _$PatientToJson(this);
}


