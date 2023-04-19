import 'package:json_annotation/json_annotation.dart';

part 'treatment.g.dart';

@JsonSerializable()
class Treatment {
  final String id;
  final String name;
  final int cost;
  DateTime? date;

  Treatment({
    required this.id,
    required this.name,
    required this.cost,
    this.date,
  });

  @override
  String toString() {
    return 'Treatment{id: $id, name: $name, cost: $cost, date: $date}';
  }

  factory Treatment.fromJson(Map<dynamic, dynamic> json) => _$TreatmentFromJson(json);
  Map<String, dynamic> toJson() => _$TreatmentToJson(this);
}
