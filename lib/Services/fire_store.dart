import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FireStore {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future uploadProfilePhoto(String userId, File profilePhoto) async {
    String? photoURL;
    try {
      //${extension(profilePhoto.path)}
      await storage.ref("users/$userId/profile").putFile(profilePhoto).then((result) async {
        photoURL = await result.ref.getDownloadURL();
      });
      return photoURL;
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }

  Future uploadPlanPhotos(String planId, List<File> planPhotos) async {
    List<String> photoURLs = [];
    try {
      for (int i = 0; i < planPhotos.length; i++) {
        await storage.ref("plans/$planId/photos/P-$i").putFile(planPhotos[i]).then((result) async {
          String url = await result.ref.getDownloadURL();
          photoURLs.add(url);
        });
      }
      return photoURLs;
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }

  Future<String> getImageUrl(String userUid) async {
    try {
      String url = await storage.ref('users/$userUid/profile').getDownloadURL();
      return url;
    } on FirebaseException catch (e) {
      print(e.code);
      return '';
    }
  }
}
