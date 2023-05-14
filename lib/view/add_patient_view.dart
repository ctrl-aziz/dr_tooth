import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/patient.dart';
import '../provider/patient_provider.dart';
import '../widget/custom_text_field.dart';

class AddPatientView extends ConsumerStatefulWidget {
  const AddPatientView({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _AddPatientViewState();
}

class _AddPatientViewState extends ConsumerState<AddPatientView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _ageController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _genderController.dispose();
    _ageController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('إضافة مريض'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    controller: _nameController,
                    labelText: 'الاسم',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _genderController,
                    labelText: 'الجنس',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a gender';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _ageController,
                    labelText: 'العمر',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter an age';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid age';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _phoneNumberController,
                    labelText: 'رقم الهاتف',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a phone number';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final newPatient = Patient(
                            id: UniqueKey().toString(),
                            name: _nameController.text,
                            gender: _genderController.text,
                            age: int.parse(_ageController.text),
                            phoneNumber: _phoneNumberController.text,
                            debts: 0,
                            treatments: [],
                            payments: [],
                          );
                          ref.read(patientStorageProvider).save(newPatient.toJson());
                          ref.invalidate(patientListProvider);
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text('حفظ'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
