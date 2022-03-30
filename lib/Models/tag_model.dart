/// ### [TagModel] interface that allows use of tags:
///
/// * UID
/// * Name
/// * Active state ( selected to delete )
class TagModel {
  String uid;
  String name;
  bool active = false;
  TagModel(this.uid,this.name);
}