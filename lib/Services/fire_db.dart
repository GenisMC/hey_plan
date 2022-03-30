import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_plan/Models/tag_model.dart';

class FireDB {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future addProfileData(String userUid, String desc, List<int> tags) async {
    CollectionReference profiles = firestore.collection('profiles');
    try {
      await profiles
          .doc(userUid)
          .set({
        'desc': desc,
        'tags': tags
      })
          .then((value) => print('User data added'))
          .catchError((error) => print('Error adding data: $error'));
    }
    on FirebaseException catch(e){
      print(e.code);
      return null;
    }
  }

  Future addTagToProfile(String userUid,List<TagModel> tags) async {
    CollectionReference profiles = firestore.collection('profiles');
    try {
      List<String> tagIds = tags.map((e) => e.uid).toList();
      return await profiles.doc(userUid).update(
          {'tags': FieldValue.arrayUnion(tagIds)});
    }
    on FirebaseException catch(e){
      print(e.code);
      return null;
    }
  }

  Future removeTagsFromProfile(String userUid, List<TagModel> tags) async {
    CollectionReference profiles = firestore.collection('profiles');
    print(tags);
    try {
      List<String> tagIds = tags.map((e) => e.uid).toList();
      return await profiles.doc(userUid).update(
          {'tags': FieldValue.arrayRemove(tagIds)});
    }
    on FirebaseException catch(e){
      print(e.code);
      return null;
    }
  }

  Future getTags(List<dynamic> tagsUids) async {
    CollectionReference tagCollection = firestore.collection('tags');

    List<TagModel> tags = [];

    try {
      for (var uid in tagsUids) {
        DocumentSnapshot doc = await tagCollection.doc(uid).get();
        tags.add(TagModel(doc.id, doc['name']));
      }
    }
    on FirebaseException catch(e){
      print(e.code);
      return null;
    }
    return tags;
  }

  Future editDescription(String userUid, String desc) async {
    CollectionReference profiles = firestore.collection('profiles');
    try {
      return await profiles.doc(userUid).update({'desc': desc});
    }
    on FirebaseException catch(e){
      print(e.code);
      return null;
    }
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
