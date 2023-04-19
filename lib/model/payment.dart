import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  final String id;
  final int amount;
  DateTime? date;

  Payment({
    required this.id,
    required this.amount,
    this.date,
  });

  @override
  String toString() {
    return 'Payment{id: $id, amount: $amount, date: $date}';
  }

  factory Payment.fromJson(Map<dynamic, dynamic> json) => _$PaymentFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}
