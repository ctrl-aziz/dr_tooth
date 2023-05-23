import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/treatment.dart';
import '../services/hive_service.dart';
import '../widget/add_dialog/treatment_form_model.dart';

final treatmentStorageProvider = Provider<TreatmentHiveService>((ref) {
  return TreatmentHiveService();
});
//
// final treatmentListProvider = FutureProvider<List<Treatment>>((ref) async {
//   final items = await ref.read(treatmentStorageProvider).getAllTreatment();
//   return items;
// });
//
//
// final treatmentModelProvider = FutureProvider<List<TreatmentFormModel>>((ref) async {
//   final items = await ref.read(treatmentListProvider.future);
//   return items.map((e) => TreatmentFormModel(e, false)).toList();
// });


final treatmentProvider = ChangeNotifierProvider.autoDispose<TreatmentProvider>((ref) {
  return TreatmentProvider();
});


class TreatmentProvider extends ChangeNotifier{
  final TreatmentHiveService _hiveService = TreatmentHiveService();
  final List<Treatment> _items = [];
  final List<TreatmentFormModel> _modelItems = [];

  List<Treatment> get treatments => _items;
  List<TreatmentFormModel> get treatmentsModel => _modelItems;

  TreatmentProvider(){
    _hiveService.getTreatmentStream().listen((event) {
      _getTreatments().then((value) => _treatmentModel());
    });
    _getTreatments().then((value) => _treatmentModel());
  }

  Future<void> _getTreatments() async {
    final items = await _hiveService.getAllTreatment();
    _items.clear();
    _items.addAll(items);
    notifyListeners();
  }

  void _treatmentModel() {
    _modelItems.addAll(_items.map((e) => TreatmentFormModel(e, false)));
    notifyListeners();
  }

  void selectItem(int i){
    _modelItems[i].value = !_modelItems[i].value;
    notifyListeners();
  }

}