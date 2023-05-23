import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import 'secure_storage.dart';

final googleSignIn = GoogleSignIn(
  scopes: [
    'email',
    'https://www.googleapis.com/auth/drive.file',
    'https://www.googleapis.com/auth/drive.appfolder',
  ],
);

class DriveService {
  final storage = SecureStorage();

  Future<AuthClient> authForFirstTime() async {
    final googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount == null) {
      throw Exception('Google sign in aborted');
    }

    final googleAuth = await googleSignInAccount.authentication;

    final authClient = authenticatedClient(
      http.Client(),
      AccessCredentials(
        AccessToken(
          'Bearer',
          googleAuth.accessToken!,
          DateTime.now().add(const Duration(days: 3)).toUtc(),
        ),
        googleAuth.accessToken,
        ['email'],
      ),
    );

    await storage.saveCredentials(authClient.credentials.accessToken,
        authClient.credentials.refreshToken!);

    return authClient;
  }

  Future<AuthClient> authenticateWithGoogle() async {
    try {
      var credentials = await storage.getCredentials();

      debugPrint("credentials: $credentials");

      if (credentials == null ||
          DateTime.parse(credentials['expiry'])
                  .difference(DateTime.now())
                  .inSeconds <=
              0) {
        return authForFirstTime();
      } else {
        final authClient = authenticatedClient(
          http.Client(),
          AccessCredentials(
            AccessToken(
              credentials["type"],
              credentials["data"],
              DateTime.tryParse(credentials["expiry"])!.toUtc(),
            ),
            credentials["refreshToken"],
            ['email'],
          ),
        );

        debugPrint("authClient: ${authClient.credentials}");
        return authClient;
      }
    } catch (e) {
      debugPrint('Error authenticating with Google: $e');
      rethrow;
    }
  }

  Future<String?> _getFolderId(ga.DriveApi driveApi) async {
    const mimeType = "application/vnd.google-apps.folder";
    String folderName = "dr_tooth";

    try {
      final found = await driveApi.files.list(
        q: "mimeType = '$mimeType' and name = '$folderName'",
        $fields: "files(id, name)",
      );
      final files = found.files;
      if (files == null) {
        debugPrint("Sign-in first Error");
        return null;
      }

      // The folder already exists
      if (files.isNotEmpty) {
        return files.first.id;
      }

      // Create a folder
      ga.File folder = ga.File();
      folder.name = folderName;
      folder.mimeType = mimeType;
      final folderCreation = await driveApi.files.create(folder);
      debugPrint("Folder ID: ${folderCreation.id}");

      return folderCreation.id;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<void> uploadFileToGoogleDrive(File file) async {
    var client = await authenticateWithGoogle();
    var drive = ga.DriveApi(client);
    String? folderId = await _getFolderId(drive);
    if (folderId == null) {
      debugPrint("Sign-in first Error");
    } else {
      ga.File fileToUpload = ga.File();
      fileToUpload.parents = [folderId];
      fileToUpload.name = DateTime.now().toString().split('.').first;
      var response = await drive.files.create(
        fileToUpload,
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()),
      );
      debugPrint(response.toString());
    }
  }

  Future<List<ga.File>> getFilesInFolder() async {
    var client = await authenticateWithGoogle();
    var drive = ga.DriveApi(client);

    final folders = await drive.files.list(
      q: "mimeType='application/vnd.google-apps.folder' and trashed = false and name = 'dr_tooth'",
    );

    if (folders.files?.isEmpty == null) {
      debugPrint('Could not find folder with name: dr_tooth');
      return [];
    }

    final folderId = folders.files!.first.id;
    final files = await drive.files.list(
      q: "'$folderId' in parents and trashed = false",
      pageSize: 5,
    );

    debugPrint("files.files: ${files.files}");

    return files.files!;
  }

  Future<void> downloadFile(String fileId, String path, {Function()? onDone}) async {
    var client = await authenticateWithGoogle();
    var drive = ga.DriveApi(client);

    final response = await drive.files
        .get(fileId, downloadOptions: ga.DownloadOptions.fullMedia) as ga.Media;

    List<int> dataStore = [];
    response.stream.listen((data) {
      debugPrint("DataReceived: ${data.length}");
      dataStore.insertAll(dataStore.length, data);
    }, onDone: () async {
      await Hive.box('patient').close();
      File file = File(path);
      await file.writeAsBytes(dataStore);
      if(onDone != null) onDone();
    }, onError: (error) {
      debugPrint("Some Error");
    });
  }
}
