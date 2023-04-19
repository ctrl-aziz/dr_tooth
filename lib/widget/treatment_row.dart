import 'package:flutter/material.dart';

import '../model/treatment.dart';

class TreatmentRow extends StatelessWidget {
  final Treatment _treatment;

  const TreatmentRow(this._treatment, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.circle,
                size: 11,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                '${_treatment.name}:',
              ),
              const SizedBox(width: 5),
              Text(
                _treatment.cost.toString(),
              ),
            ],
          ),
          Text(
            (_treatment.date ?? DateTime.now())
                .toIso8601String()
                .split('T')
                .first,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}