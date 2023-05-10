import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/patient_provider.dart';
import '../services/drive_service.dart';

class BackupView extends ConsumerWidget {
  const BackupView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('النسخ الاحتياطي/الاستعادة'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () async{
                  final boxPath = await ref.read(patientStorageProvider).boxPath;
                  print("boxPath: $boxPath");
                  final backupFile = File(boxPath);
                  // await GoogleDrive().authenticateWithGoogle();
                  // await GoogleDrive().uploadFileToGoogleDrive(backupFile);
                  await GoogleDrive().getFilesInFolder();
                },
                child: const Text("احتفاظ"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
