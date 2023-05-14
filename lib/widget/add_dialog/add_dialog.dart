import 'package:flutter/material.dart';

import 'payment_form.dart';
import 'treatment_form.dart';

class AddDialog extends StatelessWidget {
  const AddDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Dialog(
      child: DefaultTabController(
        length: 2,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TabBar(
                tabs: [
                  Tab(text: 'دفعة'),
                  Tab(text: 'تشخيص'),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 250,
                child: TabBarView(
                  children: [
                    PaymentForm(),
                    TreatmentForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}