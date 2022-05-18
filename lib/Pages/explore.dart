import 'package:flutter/material.dart';
import 'package:hey_plan/Globals/globals.dart';
import 'package:hey_plan/Models/plan_model.dart';
import 'package:hey_plan/Models/tag_model.dart';
import 'package:hey_plan/Services/singleton.dart';
import 'package:hey_plan/Widgets/empty_message.dart';
import 'package:hey_plan/Widgets/error_message.dart';
import 'package:hey_plan/Widgets/tag_picker.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({Key? key}) : super(key: key);

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

// TODO: LOAD 10 PLANS PLACE CURRENT IN MIDDLE THEN EVERY SWIPE
//  DELETES ONE FROM EDGE ADDS ONE TO THE OTHER EDGE

class _ExplorePageState extends State<ExplorePage> {
  final Singleton singleton = Singleton.instance;
  late List<PlanModel> planList = [];
  late List<TagModel> planTags = [];
  late List<TagModel> tags = [];
  Future getInitialPlans() async {
    try {
      List<String> tags = await singleton.db.getUserTags(singleton.auth.user!.uid);
      planList = await singleton.db.getDiscoverPlanList(tags);
      return planList;
    } catch (e) {
      print(e);
    }
  }

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
            return const ErrorMessage();
          } else {
            if (snapshot.data == null || snapshot.data! as List<PlanModel> == []) {
              return const EmptyMessage(
                  message: 'Parece que no podemos encontrar nada, prueba a cambiar tus preferencias.');
            } else {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          planList.first.title,
                          style: const TextStyle(fontSize: defaultFontSize * 1.3, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: MediaQuery.of(context).size.height * 0.3,
                          color: const Color(darkerBackgroundAccent),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Fecha",
                          style: TextStyle(fontSize: defaultFontSize, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TagPicker(
                          profileTags: planTags,
                          tags: tags,
                          onConfirmTagSelect: onConfirmTagSelect,
                          onDeleteTagPress: onDeleteTagPress),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                            color: Color(darkerBackgroundAccent), borderRadius: BorderRadius.all(Radius.circular(16))),
                        child: const Text(
                          "Logsd fd sal d dk sd lkdnfsk nkfdns nn kfdks l lkdsl ndnsn kfndks l lksd n sldk sl  ndksn  ",
                          style: TextStyle(fontSize: defaultFontSize),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              avatarWidget(),
                              avatarWidget(),
                              avatarWidget(),
                              avatarWidget(),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                        child: FloatingActionButton.extended(
                          onPressed: () {},
                          label: const Text("Enviar solicitud"),
                        ),
                      )
                    ],
                  ),
                ),
              );
            }
          }
        });
  }

  Widget avatarWidget() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: CircleAvatar(backgroundColor: Colors.grey),
    );
  }
}
