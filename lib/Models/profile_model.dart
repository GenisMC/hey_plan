class ProfileModel {
  String uid;
  String displayName;
  String email;
  String description;
  String? photoURL;
  List<dynamic> tags;
  ProfileModel(this.uid,this.displayName,this.email,this.description,this.photoURL,this.tags);
}