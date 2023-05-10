import 'package:flutter/material.dart';

import '../../constants/app_config.dart';
import '../../data.dart';
import 'treatment_form_model.dart';

class TreatmentForm extends StatefulWidget {
  const TreatmentForm({Key? key}) : super(key: key);

  @override
  State<TreatmentForm> createState() => _TreatmentFormState();
}

class _TreatmentFormState extends State<TreatmentForm> {
  final treatmentModel =
      treatments.map((e) => TreatmentFormModel(e, false)).toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: treatments.length,
            itemBuilder: (context, i) {
              return CheckboxListTile(
                value: treatmentModel[i].value,
                title: Text(treatmentModel[i].treatment.name),
                subtitle: Text(
                  AppConfig.numWithCurrency(treatmentModel[i].treatment.cost),
                  style: AppConfig.numberStyle,
                ),
                onChanged: (value) {
                  setState(() {
                    treatmentModel[i].value = value;
                  });
                },
              );
            },
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        ElevatedButton(
          child: const Text('إضافة'),
          onPressed: () {
            Navigator.pop(
                context,
                treatmentModel
                    .where((e) => e.value)
                    .map((e) => e.treatment..date = DateTime.now())
                    .toList());
          },
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
