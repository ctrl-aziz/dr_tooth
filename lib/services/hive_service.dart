import 'dart:convert';

import 'package:dr_tooth/model/patient.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';

import '../model/payment.dart';
import '../model/treatment.dart';

class HiveService {

  final String _boxName;

  HiveService(this._boxName);


  String? get boxPath => Hive.box(_boxName).path;

  Map<String, dynamic> get(String id)  {
    final box = Hive.box(_boxName);
    final data = box.get(id);
    final jsonString = json.decode(data);
    if (jsonString == null) {
      return {};
    }
    return Map<String, dynamic>.from(jsonString);
  }

  List getAll() {
    final box = Hive.box(_boxName);
    return box.values.map((e) => json.decode(e)).toList();
  }

  Future<void> save(Map<String, dynamic> data) async {
    final box = Hive.box(_boxName);
    final jsonString = json.encode(data);
    await box.put(data['id'], jsonString);
  }

  Future<void> delete(String id) async {
    final box = Hive.box(_boxName);
    await box.delete(id);
  }

  Stream<BoxEvent> getStream(){
    final box = Hive.box(_boxName);
    return box.watch();
  }
}

final patientStorageProvider = Provider<PatientHiveService>((ref) {
  return PatientHiveService();
});

class PatientHiveService extends HiveService{
  PatientHiveService() : super('patient');


  Patient getPatient(String id) {
    final data = super.get(id);
    return Patient.fromJson(data);
  }

  List<Patient> getAllPatient() {
    final data = super.getAll();
    return data.map((e) => Patient.fromJson(e)).toList();
  }
}

class PaymentHiveService extends HiveService{
  PaymentHiveService() : super('payment');

  Future<Payment> getPayment(String id) async {
    final data = super.get(id);
    return Payment.fromJson(data);
  }

  Future<List<Payment>> getAllPayment() async {
    final data = super.getAll();
    return data.map((e) => Payment.fromJson(e)).toList();
  }
}

class TreatmentHiveService extends HiveService{
  TreatmentHiveService() : super('treatment');

  Future<Treatment> getTreatment(String id) async {
    final data = super.get(id);
    return Treatment.fromJson(data);
  }

  Future<List<Treatment>> getAllTreatment() async {
    final data = super.getAll();
    return data.map((e) => Treatment.fromJson(e)).toList();
  }

  Stream<BoxEvent> getTreatmentStream(){
    return super.getStream();
  }
}
