class PlanModel {
  String docID;
  String title;
  String desc;
  DateTime date;
  List<dynamic> photoURLs;
  List<dynamic> tagUIDs;
  List<dynamic> userUIDs;
  bool private;
  PlanModel(this.docID, this.title, this.desc, this.date, this.photoURLs, this.tagUIDs, this.userUIDs, this.private);
}
