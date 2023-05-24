import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/app_colors.dart';
import '../constants/app_config.dart';
import '../model/patient.dart';
import '../model/payment.dart';
import '../provider/patient_provider.dart';
import '../services/hive_service.dart';
import '../widget/add_dialog/add_dialog.dart';
import '../widget/patient_row.dart';
import '../widget/treatment_row.dart';
import 'add_patient_view.dart';

class PatientView extends ConsumerWidget {
  final String id;

  const PatientView({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final patient = ref.watch(patientProvider(id));

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('بيانات المريض'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddPatientView(patient: patient),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: AlertDialog(
                        title: Text('هل تريد حذف بيانات المريض ${patient.name}؟', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.black87),),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('لا'),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(patientStorageProvider).delete(patient.id).then((value) {
                                ref.read(patientsProvider).getAllPatient();
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
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * .3,
                  child: Row(
                    children: [
                      Container(
                        height: 190,
                        width: (width * .5),
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PatientRow(
                              icon: Icons.person,
                              text: patient.name,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            PatientRow(
                              icon: Icons.cake,
                              text: '${patient.age} سنة',
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            PatientRow(
                              icon: Icons.wc,
                              text: patient.gender,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            PatientRow(
                              icon: Icons.phone,
                              text: patient.phoneNumber,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            PatientRow(
                                icon: Icons.attach_money,
                                text: AppConfig.numWithCurrency(patient.debts),
                                style: AppConfig.numberStyle),
                          ],
                        ),
                      ),
                      Container(
                        width: 2,
                        height: 190,
                        color: AppColors.primaryColor.withOpacity(.2),
                      ),
                      Container(
                        height: 190,
                        width: (width * .5) - 20,
                        padding: const EdgeInsets.only(top: 20.0),
                        child: ListView.builder(
                          itemCount: patient.treatments.length,
                          itemBuilder: (context, i) {
                            final e = patient.treatments[i];
                            return InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Directionality(
                                      textDirection: TextDirection.rtl,
                                      child: AlertDialog(
                                        title: Text(
                                          'هل تريد حذف (${e.name}) بتاريخ ${e.date!.year}/${e.date!.month}/${e.date!.day} ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(color: Colors.black87),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text('لا'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              ref
                                                  .read(patientStorageProvider)
                                                  .save(
                                                    Patient(
                                                      id: patient.id,
                                                      name: patient.name,
                                                      gender: patient.gender,
                                                      age: patient.age,
                                                      debts: patient.debts,
                                                      phoneNumber:
                                                          patient.phoneNumber,
                                                      treatments:
                                                          patient.treatments
                                                            ..remove(e),
                                                      payments:
                                                          patient.payments,
                                                    ).toJson(),
                                                  )
                                                  .then((value) {
                                                Navigator.pop(context);
                                                ref.invalidate(
                                                    patientProvider(id));
                                                ref
                                                    .read(patientsProvider)
                                                    .getAllPatient();
                                              });
                                            },
                                            child: const Text('نعم'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: TreatmentRow(e),
                            );
                          },
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
                // const DividerWidget(title: "الدفعات "),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text('الدفعات',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .5,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: patient.payments.length,
                    itemBuilder: (context, i) {
                      final payment = patient.payments[i];
                      return ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Directionality(
                                textDirection: TextDirection.rtl,
                                child: AlertDialog(
                                  title: Text(
                                    'هل تريد حذف (${payment.amount}) بتاريخ ${payment.date!.year}/${payment.date!.month}/${payment.date!.day} ',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.black87),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text('لا'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ref
                                            .read(patientStorageProvider)
                                            .save(
                                              Patient(
                                                id: patient.id,
                                                name: patient.name,
                                                gender: patient.gender,
                                                age: patient.age,
                                                debts: patient.debts,
                                                phoneNumber:
                                                    patient.phoneNumber,
                                                treatments: patient.treatments,
                                                payments: patient.payments
                                                  ..remove(payment),
                                              ).toJson(),
                                            )
                                            .then((value) {
                                          Navigator.pop(context);
                                          ref.invalidate(patientProvider(id));
                                          ref
                                              .read(patientsProvider)
                                              .getAllPatient();
                                        });
                                      },
                                      child: const Text('نعم'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        title: Text(
                          AppConfig.numWithCurrency(patient.payments[i].amount),
                          style: AppConfig.numberStyle,
                        ),
                        subtitle: Row(
                          children: [
                            const Icon(Icons.date_range),
                            Text(patient.payments[i].date!
                                .toIso8601String()
                                .split('T')
                                .first),
                          ],
                        ),
                        leading: Text((i + 1).toString()),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return const Directionality(
                  textDirection: TextDirection.rtl,
                  child: AddDialog(
                      // payments: patient.payments,
                      ),
                );
              },
            ).then((value) {
              debugPrint("value.toString(): ${value.toString()}");
              if (value != null) {
                if (value is Payment) {
                  ref.read(patientStorageProvider).save(
                        Patient(
                          id: patient.id,
                          name: patient.name,
                          gender: patient.gender,
                          age: patient.age,
                          debts: patient.debts,
                          phoneNumber: patient.phoneNumber,
                          treatments: patient.treatments,
                          payments: patient.payments..add(value),
                        ).toJson(),
                      );
                } else {
                  ref.read(patientStorageProvider).save(
                        Patient(
                          id: patient.id,
                          name: patient.name,
                          gender: patient.gender,
                          age: patient.age,
                          debts: patient.debts,
                          phoneNumber: patient.phoneNumber,
                          treatments: patient.treatments..addAll(value),
                          payments: patient.payments,
                        ).toJson(),
                      );
                }
              }
              // ref.invalidate(patientProvider(id));
              // ref.invalidate(patientListProvider);
              ref.invalidate(patientProvider(id));
              ref.read(patientsProvider).getAllPatient();
            });
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
