import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/treatment.dart';
import '../provider/treatment_provider.dart';

class AddTreatmentView extends ConsumerWidget {
  final Treatment? treatment;

  AddTreatmentView({Key? key, this.treatment}) : super(key: key);

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _cost = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(treatment == null ? 'اضافة علاج' : 'تعديل علاج'),
          actions: [
            if (treatment != null)
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: AlertDialog(
                          title: Text('هل تريد حذف (${treatment!.name}) بمبلغ ${treatment!.cost} ', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black87),),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('لا'),
                            ),
                            TextButton(
                              onPressed: () {
                                ref.read(treatmentStorageProvider).delete(treatment!.id).then((value) {
                                  Navigator.pop(context);
                                });
                              },
                              child: const Text('نعم'),
                            ),
                          ],
                        ),
                      );
                    },
                  ).then((value) {
                    Navigator.pop(context);
                  });
                },
                icon: const Icon(
                  Icons.delete,
                ),
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _name..text = treatment?.name ?? '',
                  decoration: const InputDecoration(
                    label: Text('العلاج'),
                  ),
                  validator: (value) {
                    if ((value ?? '').isEmpty) {
                      return 'لايمكن تركه فارغ';
                    } else {
                      return null;
                    }
                  },
                ),
                TextFormField(
                  controller: _cost..text = treatment?.cost.toString() ?? '',
                  decoration: const InputDecoration(
                    label: Text('التكلفة'),
                  ),
                  validator: (val) {
                    bool valid = int.tryParse(val ?? '') != null;
                    return valid ? null : 'ادخل رقم صالح';
                  },
                  keyboardType: TextInputType.number,
                ),
                TextButton(
                  onPressed: () {
                    if (_key.currentState?.validate() != null) {
                      final id = treatment != null
                          ? treatment!.id
                          : UniqueKey().toString();
                      Treatment t = Treatment(
                        id: id,
                        name: _name.text,
                        cost: int.parse(_cost.text),
                      );
                      ref
                          .read(treatmentStorageProvider)
                          .save(t.toJson())
                          .then((value) {
                        Navigator.pop(context);
                      });
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
