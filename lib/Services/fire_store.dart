import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class FireStore {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future uploadProfilePhoto(String userId,File profilePhoto) async {
    try{
      //${extension(profilePhoto.path)}
      await storage.ref("$userId/profile").putFile(profilePhoto);
    }
    on FirebaseException catch(e) {
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