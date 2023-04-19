import 'package:flutter/material.dart';

import '../../model/payment.dart';

class PaymentForm extends StatefulWidget {

  const PaymentForm({Key? key}) : super(key: key);

  @override
  State<PaymentForm> createState() => _PaymentFormState();
}

class _PaymentFormState extends State<PaymentForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int? _cost;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(labelText: 'المبلغ'),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'ادخل المبلغ';
              }
              if (int.tryParse(value) == null) {
                return 'الرجاء ادخال رقم صالح';
              }
              return null;
            },
            onSaved: (value) {
              _cost = int.parse(value!);
            },
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButton(
            child: const Text('إضافة'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                Navigator.pop(
                    context,
                    Payment(
                      id: UniqueKey().toString(),
                      amount: _cost!,
                      date: DateTime.now(),
                    )
                );
              }
            },
          ),
        ],
      ),
    );
  }
}