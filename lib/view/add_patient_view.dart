import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/patient.dart';
import '../provider/patient_provider.dart';
import '../services/hive_service.dart';
import '../widget/custom_text_field.dart';

class AddPatientView extends ConsumerStatefulWidget {
  final Patient? patient;
  const AddPatientView({
    Key? key,
    this.patient,
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
  void initState() {
    super.initState();
    if(widget.patient != null){
      _nameController.text = widget.patient!.name;
      _genderController.text = widget.patient!.gender;
      _ageController.text = widget.patient!.age.toString();
      _phoneNumberController.text = widget.patient!.phoneNumber;
    }
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
                  ToggleWidget(
                    initValue: widget.patient?.gender,
                    onItemSelected: (item) {
                      _genderController.text = item;
                      print(item);
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
                            id: widget.patient != null ? widget.patient!.id : UniqueKey().toString(),
                            name: _nameController.text,
                            gender: _genderController.text.isEmpty ? 'ذكر': _genderController.text,
                            age: int.parse(_ageController.text),
                            phoneNumber: _phoneNumberController.text,
                            debts: widget.patient != null ? widget.patient!.debts : 0,
                            treatments: widget.patient != null ? widget.patient!.treatments : [],
                            payments: widget.patient != null ? widget.patient!.payments : [],
                          );
                          ref
                              .read(patientStorageProvider)
                              .save(newPatient.toJson())
                              .then((value) {
                            ref.read(patientsProvider).getAllPatient();
                            ref.invalidate(patientProvider(newPatient.id));
                          });
                          // ref.invalidate(patientListProvider);
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

class ToggleWidget extends StatefulWidget {
  final Function(String) onItemSelected;
  final String? initValue;

  const ToggleWidget({Key? key, required this.onItemSelected, this.initValue})
      : super(key: key);

  @override
  State<ToggleWidget> createState() => _ToggleWidgetState();
}

class _ToggleWidgetState extends State<ToggleWidget> {
  List<bool> _selected = [true, false];

  @override
  void initState() {
    super.initState();
    if(widget.initValue != null){
      if(widget.initValue == 'انثى'){
        _selected = [false, true];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('الجنس'),
        const SizedBox(
          height: 5,
        ),
        ToggleButtons(
          onPressed: (i) {
            switch (i) {
              case 0:
                widget.onItemSelected('ذكر');
                break;
              case 1:
                widget.onItemSelected('انثى');
                break;
            }
            _selected = _selected.map((e) => false).toList();
            setState(() {
              _selected[i] = true;
            });
          },
          isSelected: _selected,
          children: const [
            Text('ذكر'),
            Text('انثى'),
          ],
        ),
      ],
    );
  }
}
