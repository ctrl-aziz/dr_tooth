import 'dart:convert';

import 'package:dr_tooth/model/patient.dart';
import 'package:hive_flutter/adapters.dart';

import '../model/payment.dart';
import '../model/treatment.dart';

class HiveService {

  final String _boxName;

  HiveService(this._boxName);


  Future<String> get boxPath => _openBox().then((value) => value.path!);

  Future<Box> _openBox() async {
    return await Hive.openBox(_boxName);
  }

  Future<Map<String, dynamic>> get(String id) async {
    final box = await _openBox();
    final data = box.get(id);
    final jsonString = json.decode(data);
    if (jsonString == null) {
      return {};
    }
    return Map<String, dynamic>.from(jsonString);
  }

  Future<List> getAll() async {
    final box = await _openBox();
    return box.values.map((e) => json.decode(e)).toList();
  }

  Future<void> save(Map<String, dynamic> data) async {
    final box = await _openBox();
    final jsonString = json.encode(data);
    await box.put(data['id'], jsonString);
  }

  Future<void> delete(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }
}


class PatientHiveService extends HiveService{
  PatientHiveService() : super('patient');


  Future<Patient> getPatient(String id) async {
    final data = await super.get(id);
    return Patient.fromJson(data);
  }

  Future<List<Patient>> getAllPatient() async {
    final data = await super.getAll();
    return data.map((e) => Patient.fromJson(e)).toList();
  }
}

class PaymentHiveService extends HiveService{
  PaymentHiveService() : super('payment');

  Future<Payment> getPayment(String id) async {
    final data = await super.get(id);
    return Payment.fromJson(data);
  }

  Future<List<Payment>> getAllPayment() async {
    final data = await super.getAll();
    return data.map((e) => Payment.fromJson(e)).toList();
  }
}

class TreatmentHiveService extends HiveService{
  TreatmentHiveService() : super('treatment');

  Future<Treatment> getTreatment(String id) async {
    final data = await super.get(id);
    return Treatment.fromJson(data);
  }

  Future<List<Treatment>> getAllTreatment() async {
    final data = await super.getAll();
    return data.map((e) => Treatment.fromJson(e)).toList();
  }
}
