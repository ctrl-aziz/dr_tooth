import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/patient_provider.dart';
import '../widget/custom_search.dart';
import 'add_patient_view.dart';
import 'patient_view.dart';

class DentalPatientsView extends ConsumerWidget {
  const DentalPatientsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(patientListProvider);
    final filteredPatients = ref.watch(filteredPatientProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تطبيق مرضى الأسنان'),
        ),
        body: patients.when(
          data: (patients) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: CustomSearch(
                    hintText: 'ابحث عن مريض',
                    items: patients,
                    onFiltered: (searchText) {
                      ref.read(filteredPatientProvider.notifier).state =
                          patients
                              .where((item) => item.name
                                  .toLowerCase()
                                  .contains(searchText.toLowerCase()))
                              .toList();
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: (filteredPatients ?? patients).length,
                    itemBuilder: (BuildContext context, int i) {
                      final item = (filteredPatients ?? patients)[i];
                      final int age = item.age;
                      return Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PatientView(
                                  id: item.id,
                                ),
                              ),
                            );
                          },
                          title: Text(item.name),
                          subtitle: Text(item.debts.toString()),
                          leading: Text((i + 1).toString()),
                          trailing:
                              Icon(age < 18 ? Icons.child_care : Icons.person),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
          error: (e, s) {
            return Text("Error: $e");
          },
          loading: () => const CircularProgressIndicator(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddPatientView(),
              ),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

