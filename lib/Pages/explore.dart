import 'package:flutter/material.dart';
import 'package:hey_plan/Globals/globals.dart';
import 'package:hey_plan/Models/plan_model.dart';
import 'package:hey_plan/Models/tag_model.dart';
import 'package:hey_plan/Widgets/tag_picker.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

// TODO: LOAD 10 PLANS PLACE CURRENT IN MIDDLE THEN EVERY SWIPE
//  DELETES ONE FROM EDGE ADDS ONE TO THE OTHER EDGE

class _ExplorePageState extends State<ExplorePage> {
  late List<PlanModel> planList = [];
  late List<TagModel> planTags = [];
  late List<TagModel> tags = [];
  Future getInitialPlans() async {}
  void onConfirmTagSelect() {}
  void onDeleteTagPress() {}
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getInitialPlans(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              child: Center(
                  child: Text(
                "Cargando...",
                style: TextStyle(fontSize: defaultFontSize),
              )),
            );
          } else if (snapshot.hasError) {
            return const SizedBox(
              child: Center(child: Text("Error")),
            );
          } else {
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text("Plan"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.3,
                        color: const Color(darkerBackgroundAccent),
                      ),
                    ),
                    TagPicker(
                        profileTags: planTags,
                        tags: tags,
                        onConfirmTagSelect: onConfirmTagSelect,
                        onDeleteTagPress: onDeleteTagPress),
                  ],
                ),
              ),
            );
          }
        });
  }
}
