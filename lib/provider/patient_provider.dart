import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/patient.dart';
import '../services/drive_service.dart';
import '../services/hive_service.dart';


final patientProvider = StateProvider.family<Patient, String>((ref, id) {
  return ref.read(patientsProvider).getPatient(id);
});


final driveProvider = Provider<DriveService>((ref) {
  return DriveService();
});

final patientsProvider = ChangeNotifierProvider<PatientsProvider>((ref) {
  return PatientsProvider();
});

class PatientsProvider extends ChangeNotifier{
  final PatientHiveService _patientHiveService = PatientHiveService();

  List<Patient> _patients = [];
  List<Patient> get patients => _patients;
  List<Patient>? _filteredPatients;
  List<Patient>? get filteredPatients => _filteredPatients;

  PatientsProvider(){
    getAllPatient();
  }

  void getAllPatient() {
    _patients = _patientHiveService.getAllPatient();
    notifyListeners();
  }

  void filteredPatientProvider(searchText) {
    _filteredPatients =
        _patients
            .where((item) => item.name
            .toLowerCase()
            .contains(searchText.toLowerCase()))
            .toList();
    notifyListeners();
  }

  Patient getPatient(String id){
    return _patientHiveService.getPatient(id);
  }
}