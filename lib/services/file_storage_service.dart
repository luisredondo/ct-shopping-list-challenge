import 'dart:io';
import 'package:path/path.dart' as path;

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FileStorageServiceException implements Exception {}

class UploadingError implements FileStorageServiceException {
  final String message;
  UploadingError(this.message);
}

class FileStorageService {

  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;

  Future<String> uploadImage(File file) async {
    try {
      final filename = path.basename(file.path);
      final storageRef = storage.ref().child("images/$filename");
      final uploadTask = storageRef.putFile(file);
      String downloadUrl = "";
      uploadTask.then((taskSnapshot) async => {
        downloadUrl = await taskSnapshot.ref.getDownloadURL(),
      },);
      return downloadUrl;
    } catch (e) {
      throw UploadingError(e.toString());
    }
  }

}
