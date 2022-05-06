class PlanModel {
  String docID;
  String title;
  DateTime date;
  List<dynamic> photoURLs;
  List<dynamic> userUIDs;
  bool private;
  PlanModel(this.docID, this.title, this.date, this.photoURLs, this.userUIDs, this.private);
}
