// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Patient _$PatientFromJson(Map<String, dynamic> json) => Patient(
      id: json['id'] as String,
      name: json['name'] as String,
      gender: json['gender'] as String,
      age: json['age'] as int,
      debts: json['debts'] as int,
      phoneNumber: json['phoneNumber'] as String,
      treatments: (json['treatments'] as List<dynamic>)
          .map((e) => Treatment.fromJson(e as Map<String, dynamic>))
          .toList(),
      payments: (json['payments'] as List<dynamic>)
          .map((e) => Payment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PatientToJson(Patient instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'gender': instance.gender,
      'age': instance.age,
      'phoneNumber': instance.phoneNumber,
      'debts': instance.debts,
      'treatments': instance.treatments,
      'payments': instance.payments,
    };
