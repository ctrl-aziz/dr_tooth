import 'package:dr_tooth/view/statistics_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/patient.dart';
import '../provider/patient_provider.dart';
import 'backup_view.dart';
import 'treatments_view.dart';

class SettingView extends ConsumerWidget {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الاعدادات'),
        ),
        body: Column(
          children: [
            ListTile(
              title: const Text('النسح الاحتياطي'),
              subtitle: const Text('قم بإنشاء نسخ احتياطية لبياناتك لحمايتها'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BackupView(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('خدماتك'),
              subtitle: const Text('ادخل انواع العلاج التي تقدمها'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TreatmentsView(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('احصائيات'),
              subtitle: const Text('عرض الإحصائيات الخاصة بك'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                final patients = ref.read(patientsProvider).patients;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatisticsView(
                      dailyIncome: _getIncome(patients, 1),
                      monthlyIncome: _getIncome(patients, 30),
                      totalDebt: _getDebit(patients),
                    ),
                  ),
                );
              },
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }

  int _getIncome(List<Patient> patients, int days){
    final paymentsList = patients.map((e) => e.payments).toList();
    if(paymentsList.isEmpty) return 0;
    final datedPayments = paymentsList.map((e) => e.where((e) => e.date!.difference(DateTime.now()).inDays < days).toList()).toList();
    if(datedPayments.isEmpty) return 0;
    final paymentsAmounts = datedPayments.map((e) => e.map((e) => e.amount));
    if(paymentsAmounts.isEmpty) return 0;
    final paymentsTotal = paymentsAmounts.map((e) => (e.isEmpty ? [0,0] : e).reduce((v, e) => v + e)).reduce((v, e) => v + e);
    return paymentsTotal;
  }

  int _getDebit(List<Patient> patients){
    if(patients.isEmpty) return 0;
    final totalDebit = patients.map((e) => e.debts).reduce((v, e) => v + e);
    return totalDebit;

  }
}

class _NameDialog extends ConsumerStatefulWidget {
  const _NameDialog({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => __NameDialogState();
}

class __NameDialogState extends ConsumerState<_NameDialog> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    initName();
  }

  void initName() async {
    // final name = await ref.read(nameProvider.future);
    // _controller.text = name;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change name'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          hintText: 'Enter your name',
        ),
      ),
      actions: [
        TextButton(
          child: const Text('CANCEL'),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () => Navigator.pop(context, _controller.text),
        ),
      ],
    );
  }
}
