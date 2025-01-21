import 'package:appwrite/appwrite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class AppwriteService {
  late final Client _client;
  late final Storage _storage;
  late final FirebaseFirestore _firestore;

  late final String _projectId;

  AppwriteService() {
    _client = Client();
    _projectId = '678e3c4f0022f35b7d40';
    _client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(_projectId)
        .setSelfSigned(status: true);
    _storage = Storage(_client);
    _firestore = FirebaseFirestore.instance;
  }

  Future<String?> uploadFile(String projectId, BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        final file = result.files.first;
        final inputFile = InputFile.fromPath(path: file.path!);
        final response = await _storage.createFile(
          bucketId: '678e44be000722683a5b',
          fileId: const Uuid().v4(),
          file: inputFile,
          // permissions: [
          //   Permission.read(Role.any()),
          //   Permission.write(Role.any())
          // ],
        );
        final downloadURL = getDownloadFile(
          response.$id,
          '678e44be000722683a5b',
        );
        final projectRef = _firestore.collection('projects').doc(projectId);
        await projectRef.update({
          'attachments': FieldValue.arrayUnion([downloadURL])
        });

        // ignore: use_build_context_synchronously
        showSnackbar(context, 'Success', 'File uploaded successfully');
        return response.$id;
      }
      return null;
    } on AppwriteException catch (e) {
      // ignore: use_build_context_synchronously
      showSnackbar(context, 'Error', 'Failed to upload file: ${e.message}');
      return null;
    }
  }

  String getDownloadFile(String fileId, String bucketId) {
    return '$_client.endPoint/storage/buckets/$bucketId/files/$fileId/view?project=$_projectId';
  }

  void showSnackbar(BuildContext context, String title, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$title: $message'),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
