import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:social_media_app/utils/file_utils.dart';
import 'package:social_media_app/utils/firebase.dart';

abstract class Service {
  //function to upload images to firebase storage and retrieve the url.
  Future<String> uploadImage(Reference ref, File file) async {
    String ext = FileUtils.getFileExtension(file);
    Reference storageReference = ref.child("${uuid.v4()}.$ext");
    UploadTask uploadTask = storageReference.putFile(file);
    await uploadTask.whenComplete(() => null);
    String fileUrl = await storageReference.getDownloadURL();
    return fileUrl;
  }
}

// Future<String> uploadImage(Reference ref, File file) async {
//   String? ext = path.extension(file.path);
//   var uuid = Uuid();
//   Reference storageReference = ref.child("${uuid.v4()}$ext");
//   UploadTask uploadTask = storageReference.putFile(file);
//   if (await file.exists()) {
//     try {
//       TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
//       if (snapshot.state == TaskState.success) {
//         String fileUrl = await storageReference.getDownloadURL();
//         return fileUrl;
//       } else {
//         throw Exception('Upload task did not complete successfully');
//       }
//     } catch (e) {
//       print("Upload failed with error: $e");
//       throw Exception("Upload failed: $e");
//     }
//   } else {
//     print("File does not exist: ${file.path}");
//     throw Exception("File does not exist: ${file.path}");
//   }