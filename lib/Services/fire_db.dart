import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hey_plan/Models/friend_model.dart';
import 'package:hey_plan/Models/plan_model.dart';
import 'package:hey_plan/Models/tag_model.dart';

class FireDB {
  /// ### [FirebaseFirestore.instance] to reference all firestore functions
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /// ### Add description and tag list to cloud user profile
  ///
  /// Requires a [String] userUID, [String] desciption and [List] [String] Taglist.
  /// References the collection 'profiles' and inserts into the document where the
  /// [DocId] = [userUID], the description and tag reference list.
  Future addProfileData(String surname, int age, String name, String userUid, String desc, List<String> tags) async {
    CollectionReference profiles = firestore.collection('profiles');
    try {
      await profiles
          .doc(userUid)
          .set({'name': name, 'surname': surname, 'age': age, 'desc': desc, 'tags': tags})
          .then((value) => print('User data added'))
          .catchError((error) => print('Error adding data: $error'));
    } on FirebaseException catch (e) {
      print(e.code);
      return null;
    }
  }

  /// ### Adds a list of tags to the provided user's profile
  ///
  /// Requires a [String] userUID and a [List] [String] list of tag references.
  /// Thes uses the collection 'profiles' to add to the list of tags of the
  /// user.
  Future addTagToProfile(String userUid, List<String> tags) async {
    CollectionReference profiles = firestore.collection('profiles');
    try {
      return await profiles.doc(userUid).update({'tags': FieldValue.arrayUnion(tags)});
    } on FirebaseException catch (e) {
      print(e.code);
      return null;
    }
  }

  /// ### Removes a list of tags from the provided user's profile
  ///
  /// Requires a [Strnig] userUID and a [List] [String] list of tag references.
  /// Then uses the collection 'profiles' to remove from the list of tags the
  /// user already has.
  Future removeTagsFromProfile(String userUid, List<String> tags) async {
    CollectionReference profiles = firestore.collection('profiles');
    try {
      return await profiles.doc(userUid).update({'tags': FieldValue.arrayRemove(tags)});
    } on FirebaseException catch (e) {
      print(e.code);
      return null;
    }
  }

  /// ### Gets the list of all tags and their info given a list of references
  ///
  /// Requires [List] [String] tag references. References the collection 'tags'
  /// and queries the chosen tags given their UIDs.
  Future getProfileTags(List<dynamic> tagsUids) async {
    CollectionReference tagCollection = firestore.collection('tags');

    List<TagModel> tags = [];

    try {
      for (var uid in tagsUids) {
        DocumentSnapshot doc = await tagCollection.doc(uid).get();
        tags.add(TagModel(doc.id, doc['name']));
      }
    } on FirebaseException catch (e) {
      print(e.code);
      return null;
    }
    return tags;
  }

  Future getTags() async {
    CollectionReference tagCollection = firestore.collection('tags');

    List<TagModel> tags = [];

    await tagCollection.get().then((value) {
      value.docs.forEach((document) {
        tags.add(TagModel(document.id, document.get('name')));
      });
    });

    return tags;
  }

  /// ### Updates the given user's profile description
  ///
  /// Given a [String] userUID and a [String] description, references the
  /// collection 'profiles' and replaces the current description with the given
  /// one from the given user.
  Future editDescription(String userUid, String desc) async {
    CollectionReference profiles = firestore.collection('profiles');
    try {
      return await profiles.doc(userUid).update({'desc': desc});
    } on FirebaseException catch (e) {
      print(e.code);
      return null;
    }
  }

  /// ### Gets all of the user's profile data
  ///
  /// Given a [String] userUID, gets the users description and tag reference
  /// list. In other words, all of the user information stored in the firestore
  /// database.
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

  /// ### Adds a plan to the plans collection
  ///
  /// Requires a ``List<String>`` userUIDs, ``List<String`` photoURLs, ``DateTime`` date of the pla, ``bool`` private or public
  /// and TODO: add the rest of the fields like the location and the user list. After that it adds a new record with
  /// a random id to the collection.
  Future createNewPlan(String title, String desc, String docUid, List<String> userUIDs, DateTime date,
      List<String> photoURLs, List<String> tags, bool private) async {
    CollectionReference plans = firestore.collection('plans');

    try {
      return await plans.doc(docUid).set({
        'users': userUIDs,
        'title': title,
        'description': desc,
        'photos': photoURLs,
        'tags': tags,
        'date': date,
        'private': private
      });
    } on FirebaseException catch (e) {
      print(e.code);
    }
  }

  /// ### TODO. Currently gets all plans in the plans collection
  ///
  /// Algorithm in progress
  Future getDiscoverPlanList(List<String> tagUIDs, List<String> docUIDs) async {
    CollectionReference plans = firestore.collection('plans');
    List<PlanModel> planList = [];

    if (docUIDs.isNotEmpty) {
      await plans.where("__name__", whereNotIn: docUIDs).limit(10).get().then((plans) {
        for (var planData in plans.docs) {
          planList.add(
            PlanModel(
              planData.id,
              planData.get('title'),
              planData.get('description'),
              planData.get('date').toDate(),
              planData.get('photos'),
              planData.get('tags'),
              planData.get('users'),
              planData.get('private'),
            ),
          );
        }
      });
    } else {
      await plans.where("tags", arrayContainsAny: tagUIDs).limit(10).get().then((plans) {
        for (var planData in plans.docs) {
          planList.add(
            PlanModel(
              planData.id,
              planData.get('title'),
              planData.get('description'),
              planData.get('date').toDate(),
              planData.get('photos'),
              planData.get('tags'),
              planData.get('users'),
              planData.get('private'),
            ),
          );
        }
      });
    }

    return planList;
  }

  Future getUserPlans(String userUID) async {
    List<PlanModel> planList = [];

    await firestore.collection('plans').where("users", arrayContains: userUID).get().then((plans) {
      for (var planData in plans.docs) {
        planList.add(
          PlanModel(
            planData.id,
            planData.get('title'),
            planData.get('description'),
            planData.get('date').toDate(),
            planData.get('photos'),
            planData.get('tags'),
            planData.get('users'),
            planData.get('private'),
          ),
        );
      }
    });

    return planList;
  }

  Future getUserTags(String userUID) async {
    CollectionReference profiles = firestore.collection('profiles');

    List<String> tags = [];

    await profiles.doc(userUID).get().then((doc) {
      for (var tag in doc.get('tags')) {
        tags.add(tag);
      }
    });

    return tags;
  }

  Future removeUserFromPLan(String docId, String userUID) async {
    CollectionReference plans = firestore.collection('plans');
    Function eq = const ListEquality().equals;
    bool deleted = false;

    var docRef = await plans.doc(docId).get().then((docSnapshot) async {
      if (eq(docSnapshot.get('users'), [userUID])) {
        deleted = true;
        await plans.doc(docId).delete();
      } else {
        await plans.doc(docId).update({
          'users': FieldValue.arrayRemove([userUID])
        });
      }
    });
    if (deleted) {
      return 1;
    }
    return 0;
  }

  Future addFriend(String userUID, String friendUID) async {
    CollectionReference profiles = firestore.collection('profiles');
    if (friendUID != "") {
      try {
        //check if user already has friend
        await profiles.doc(userUID).get().then((doc) {
          if (doc.get('friends').contains(friendUID)) {
            return 0;
          }
        });

        // check if friend exists
        profiles.doc(friendUID).get().then((doc) {
          if (doc.exists) {
            // add friend to user
            profiles.doc(userUID).update({
              'friends': FieldValue.arrayUnion([friendUID])
            });
            return 1;
          }
        });
      } catch (e) {
        print(e);
        return -1;
      }
    }
    return -1;
  }

  Future getFriendList(String userUID) async {
    CollectionReference profiles = firestore.collection('profiles');
    List<FriendModel> friendList = [];

    try {
      await profiles.doc(userUID).get().then((doc) async {
        var data = doc.data() as Map<String, dynamic>;
        List<dynamic> friends = data['friends'] ?? [];

        if (friends.isNotEmpty) {
          for (var friend in friends) {
            await profiles.doc(friend).get().then((doc) {
              var data = doc.data() as Map<String, dynamic>;
              friendList.add(FriendModel(id: friend, name: data["name"] ?? "", avatar: friend));
            });
          }
        }

        return friendList;
      });
    } catch (e) {
      print(e);
    }
    return friendList;
  }

  Future<String> checkIfChatExists(String userUID, String friendUID) async {
    CollectionReference chats = firestore.collection('chats');
    String chatUID = "";
    String chatUID2 = "";
    bool chatAdmin = false;
    try {
      chatUID = sha256.convert(utf8.encode(userUID + friendUID)).toString();
      chatUID2 = sha256.convert(utf8.encode(friendUID + userUID)).toString();
      await chats.doc(chatUID).get().then((doc) {
        if (!doc.exists) {
          chats.doc(chatUID2).get().then((doc) {
            if (!doc.exists) {
              chats.doc(chatUID).set({
                'users': [userUID, friendUID]
              });
            } else {
              chatAdmin = false;
            }
          });
        } else {
          chatAdmin = true;
        }
      });
    } catch (e) {
      print(e);
    }
    return chatAdmin ? chatUID : chatUID2;
  }

  Future sendMessage(String chatUID, String userUID, String message) async {
    CollectionReference chats = firestore.collection('chats');
    try {
      await chats.doc(chatUID).update({
        'messages': FieldValue.arrayUnion([
          {'user': userUID, 'message': message, 'date': DateTime.now()}
        ])
      });
    } catch (e) {
      print(e);
    }
  }

  Stream<DocumentSnapshot> chatStream(String chatUID) {
    final docRef = firestore.collection("chats").doc(chatUID);
    return docRef.snapshots();
  }
}
