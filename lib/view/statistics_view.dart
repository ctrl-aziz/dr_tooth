import 'package:flutter/material.dart';

class StatisticsView extends StatelessWidget {
  final int totalDebt;
  final int dailyIncome;
  final int monthlyIncome;

  const StatisticsView({
    Key? key,
    required this.totalDebt,
    required this.dailyIncome,
    required this.monthlyIncome,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الإحصائيات'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width * .5)-25,
                    height: (MediaQuery.of(context).size.width * .5) - 25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'الدخل الشهري',
                          style: TextStyle(fontSize: 19),
                        ),
                        Text(
                          monthlyIncome.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
                Card(
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width * .5) - 25,
                    height: (MediaQuery.of(context).size.width * .5) - 25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'الدخل اليومي',
                          style: TextStyle(fontSize: 19),
                        ),
                        Text(
                          dailyIncome.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  child: SizedBox(
                    width: (MediaQuery.of(context).size.width * .5)-25,
                    height: (MediaQuery.of(context).size.width * .5) - 25,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'الدين الإجمالي',
                          style: TextStyle(fontSize: 19),
                        ),
                        Text(
                          totalDebt.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
