import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_config.dart';
import '../provider/patient_provider.dart';
import '../widget/custom_search.dart';
import 'add_patient_view.dart';
import 'patient_view.dart';
import 'settings_view.dart';

class DentalPatientsView extends ConsumerWidget {
  const DentalPatientsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patients = ref.watch(patientsProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تطبيق مرضى الأسنان'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingView(),
                  ),
                );
              },
              icon: const Icon(
                Icons.settings,
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: CustomSearch(
                hintText: 'ابحث عن مريض',
                items: patients.patients,
                onFiltered: patients.filteredPatientProvider,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async{
                  patients.getAllPatient();
                },
                child: ListView.builder(
                  itemCount: (patients.filteredPatients ?? patients.patients).length,
                  itemBuilder: (BuildContext context, int i) {
                    final item = (patients.filteredPatients ?? patients.patients)[i];
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
                        subtitle: Text(
                          AppConfig.numWithCurrency(item.debts),
                          style: AppConfig.numberStyle,
                        ),
                        leading: Text((i + 1).toString()),
                        trailing:
                        Icon(age < 18 ? Icons.child_care : Icons.person),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
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
