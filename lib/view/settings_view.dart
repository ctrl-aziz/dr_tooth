
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
              subtitle:
              const Text('قم بإنشاء نسخ احتياطية لبياناتك لحمايتها'),
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
              subtitle:
              const Text('ادخل انواع العلاج التي تقدمها'),
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


            // ListView.builder(
            //   itemCount: treatments.length,
            //   itemBuilder: (context, i) {
            //     final e = treatments[i];
            //     return ListTile(
            //       title: Text(e.name),
            //       trailing: Text(
            //         AppConfig.numWithCurrency(e.cost),
            //         style: AppConfig.numberStyle,
            //       ),
            //       onTap: (){
            //
            //       },
            //     );
            //   },
            //   padding: EdgeInsets.zero,
            // ),
          ],
        ),
      ),
    );
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
