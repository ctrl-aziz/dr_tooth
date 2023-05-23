import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/treatment_provider.dart';
import 'add_treatment_view.dart';

class TreatmentsView extends ConsumerWidget {
  const TreatmentsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final treatments = ref.watch(treatmentProvider).treatments;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("أنواع العلاج"),
        ),
        body: ListView.builder(
          itemCount: treatments.length,
          itemBuilder: (context, i) {
            return Card(
              child: ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTreatmentView(
                        treatment: treatments[i],
                      ),
                    ),
                  );
                },
                title: Text(treatments[i].name),
                trailing: Text('${treatments[i].cost}'),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTreatmentView(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
