import 'package:hey_plan/Models/tag_model.dart';

/// ### [ProfileModel] interface that makes easier to manage the user data:
///
/// * UID
/// * Name
/// * Email
/// * Description
/// * URL of its profile photo
/// * List of [TagModel] in his profile
class ProfileModel {
  String uid;
  String displayName;
  String email;
  String description;
  String? photoURL;
  List<TagModel> tags;
  ProfileModel(this.uid, this.displayName, this.email, this.description, this.photoURL, this.tags);

  void fromJson(String uid, Map<String, dynamic> json) {
    this.uid = uid;
    displayName = json['name'] ?? "";
    email = json['email'] ?? "";
    description = json['desc'] ?? "";
    photoURL = json['photoURL'] ?? "";
    tags = [];
  }
}
