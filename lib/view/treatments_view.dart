import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/treatment.dart';
import '../provider/treatment_provider.dart';

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
                builder: (context) => AddTreatment(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

class AddTreatment extends ConsumerWidget {
  AddTreatment({Key? key}) : super(key: key);

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _cost = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('اضافة علاج'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(
                    label: Text('العلاج'),
                  ),
                  validator: (value){
                    if((value??'').isEmpty){
                      return 'لايمكن تركه فارغ';
                    }else{
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: _cost,
                  decoration: const InputDecoration(
                    label: Text('التكلفة'),
                  ),
                  validator: (val){
                    bool valid = int.tryParse(val??'') != null;
                    return valid ? null : 'ادخل رقم صالح';
                  },
                  keyboardType: TextInputType.number,
                ),
                TextButton(
                  onPressed: () {
                    if (_key.currentState?.validate() != null) {
                      Treatment treatment = Treatment(
                        id: UniqueKey().toString(),
                        name: _name.text,
                        cost: int.parse(_cost.text),
                      );
                      ref.read(treatmentStorageProvider).save(treatment.toJson());
                    }
                  },
                  child: const Text('حفظ'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
