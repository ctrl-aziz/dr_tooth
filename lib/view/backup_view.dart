import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:hive/hive.dart';
import 'dart:io' as io;

import '../provider/patient_provider.dart';
import '../services/hive_service.dart';

final _backupLoadingProvider = StateProvider<bool>((ref) {
  return false;
});

final _driveFilesProvider = FutureProvider<List<File>>((ref) async {
  return ref.read(driveProvider).getFilesInFolder();
});

class BackupView extends ConsumerWidget {
  const BackupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBackupLoading = ref.watch(_backupLoadingProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('النسخ الاحتياطي/الاستعادة'),
          actions: [
            IconButton(
              onPressed: () async {
                try{
                  final path = ref.read(patientStorageProvider).boxPath;
                  final io.File file = io.File(path!);
                  await ref.read(driveProvider).uploadFileToGoogleDrive(file);
                  ref.invalidate(_driveFilesProvider);
                }catch(e){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'يرجى تسجيل الدخول اولاً',
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(
                Icons.backup,
              ),
            )
          ],
        ),
        body: isBackupLoading
            ? SizedBox(
                width: MediaQuery.of(context).size.width,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(' يرجى عدم اغلاق التطبيق'),
                    SizedBox(
                      height: 5,
                    ),
                    Text('جار تحميل النسخة الاحتياطية'),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      width: 50,
                      child: LinearProgressIndicator(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            : ref.watch(_driveFilesProvider).when(
                  data: (files) {
                    return ListView.builder(
                      itemCount: files.length,
                      itemBuilder: (cntxt, i) {
                        final File file = files[i];
                        // print("${file}");

                        return ListTile(
                          onTap: () async {
                            final downloadIt = await showDialog<bool>(
                              context: context,
                              builder: (context) {
                                return Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: AlertDialog(
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                            'هل تريد استعادة هذه النسخة'),
                                        Text(file.name!),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                        child: const Text('لا'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: const Text('نعم'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                            if (downloadIt ?? false) {
                              ref.read(_backupLoadingProvider.notifier).state =
                                  true;
                              debugPrint(file.id);
                              final path =
                                  ref.read(patientStorageProvider).boxPath;
                              await ref.read(driveProvider).downloadFile(
                                file.id!,
                                path!,
                                onDone: () async {
                                  await Hive.openBox('patient').then((value) {
                                    // Navigator.pushAndRemoveUntil(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //     const DentalPatientsView(),
                                    //   ),
                                    //       (route) => true,
                                    // );
                                    ref.read(patientsProvider).getAllPatient();
                                    ref
                                        .read(_backupLoadingProvider.notifier)
                                        .state = false;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'تم الاستعادة بنجاح',
                                        ),
                                      ),
                                    );
                                  });
                                },
                              );
                            }
                          },
                          title: Text("نسخة بتاريخ: ${file.name}"),
                        );
                      },
                    );
                  },
                  error: (e, s) => Center(
                    child: TextButton(
                      onPressed: () async {
                        await ref.read(driveProvider).authForFirstTime();
                        ref.invalidate(_driveFilesProvider);
                      },
                      child: const Text("سجل دخول"),
                    ),
                  ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                ),
      ),
    );
  }
}
