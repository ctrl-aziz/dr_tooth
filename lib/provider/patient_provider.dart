
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/patient.dart';
import '../services/drive_service.dart';
import '../services/hive_service.dart';

final patientStorageProvider = Provider<PatientHiveService>((ref) {
  return PatientHiveService();
});

final patientListProvider = FutureProvider<List<Patient>>((ref) async {
  final items = await ref.read(patientStorageProvider).getAllPatient();
  return items;
});

final patientProvider = FutureProvider.family<Patient, String>((ref, id) async {
  final item = await ref.read(patientStorageProvider).getPatient(id);
  return item;
});

final filteredPatientProvider = StateProvider<List<Patient>?>((ref) {
  return;
});

final driveProvider = Provider<DriveService>((ref) {
  return DriveService();
});



class CounterState extends StateNotifier<int> {
  CounterState() : super(0);

  void increment() => state++;
}

// Define a provider for the state class
final counterProvider = StateNotifierProvider<CounterState, int>((ref) {
  return CounterState();
});

