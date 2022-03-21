import 'package:cloud_firestore/cloud_firestore.dart';

class FireDB {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future addProfileData(String userUid, String desc, List<int> tags) async {
    CollectionReference profiles = firestore.collection('profiles');

    await profiles
        .doc(userUid)
        .set({
          'desc': desc,
          'tags': tags
        })
        .then((value) => print('User data added'))
        .catchError((error) => print('Error adding data: $error'));
  }

  Future addTagToProfile(String userUid,List<String> tag) async {
    CollectionReference profiles = firestore.collection('profiles');

    return await profiles.doc(userUid).update({'tags': FieldValue.arrayUnion(tag)});
  }

  Future removeTagFromProfile(String userUid, List<String> tag) async {
    CollectionReference profiles = firestore.collection('profiles');

    return await profiles.doc(userUid).update({'tags': FieldValue.arrayRemove(tag)});
  }

  Future editDescription(String userUid, String desc) async {
    CollectionReference profiles = firestore.collection('profiles');
    return await profiles.doc(userUid).update({'desc': desc});
  }

  Future getProfileData(String userUid) async {
    CollectionReference profiles = firestore.collection('profiles');

    try {
      DocumentSnapshot doc = await profiles.doc(userUid).get();
      return doc.data();
    } on FirebaseException catch (e) {
      print('Error reading user data: $e');
      return null;
    }
  }
}
