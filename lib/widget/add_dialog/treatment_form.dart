import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_config.dart';
import '../../provider/treatment_provider.dart';

class TreatmentForm extends ConsumerWidget {
  const TreatmentForm({
    Key? key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treatment = ref.watch(treatmentProvider);
    // final treatmentModel = ref.watch(treatmentModelProvider);

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: treatment.treatments.length,
            itemBuilder: (context, i) {
              return CheckboxListTile(
                value: treatment.treatmentsModel[i].value,
                title: Text(treatment.treatmentsModel[i].treatment.name),
                subtitle: Text(
                  AppConfig.numWithCurrency(
                      treatment.treatmentsModel[i].treatment.cost),
                  style: AppConfig.numberStyle,
                ),
                onChanged: (value) {
                  treatment.selectItem(i);
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
                treatment.treatmentsModel
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
