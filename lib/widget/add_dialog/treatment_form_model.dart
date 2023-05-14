import '../../model/treatment.dart';

class TreatmentFormModel{
  final Treatment treatment;
  bool _value;

  TreatmentFormModel(this.treatment, this._value);

  bool get value => _value;

  set value(bool val){
    if(val == _value) return;
    _value = val;
  }
}