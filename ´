import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FireStore {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future uploadProfilePhoto(String userId,File profilePhoto) async {
    String? photoURL;
    try{
      //${extension(profilePhoto.path)}
      await storage.ref("$userId/profile").putFile(profilePhoto).then((result) async {
          photoURL = await result.ref.getDownloadURL();
        });
      return photoURL;
    }
    on FirebaseException catch(e) {
      print(e.code);
    }
  }

  Future uploadPlanPhoto(String planId, File planPhoto) async {
    String? photoURL;
    try{
        await storage.ref("$planId/photos/UID").putFile(planPhoto).then((result) async {
            photoURL = await result.ref.getDownloadURL();
          });
        return photoURL;
      } on FirebaseException catch(e) {
        print(e.code);
      }
  }

  Future<String> getImageUrl(String userUid) async {
    try{
      print(userUid);
      String url = await storage.ref('$userUid/profile').getDownloadURL();
      print(url);
      return url;
    }
    on FirebaseException catch(e) {
      print(e.code);
      return '';
    }
  }
}
