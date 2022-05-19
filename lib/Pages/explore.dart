import 'package:carousel_slider/carousel_slider.dart';
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
  int index = 0;
  late List<PlanModel> planList = [];
  late List<TagModel> planTags = [];
  late List<TagModel> tags = [];
  Future getInitialPlans() async {
    try {
      List<String> tags = await singleton.db.getUserTags(singleton.auth.user!.uid);
      planList = await singleton.db.getDiscoverPlanList(tags);
      planTags = await singleton.db.getProfileTags(planList[index].tagUIDs);
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
              DateTime fechaDT = planList[index].date;
              String month = fechaDT.month < 10 ? "0" + fechaDT.month.toString() : fechaDT.month.toString();
              String minute = fechaDT.minute < 10 ? "0" + fechaDT.minute.toString() : fechaDT.minute.toString();
              String fecha = "${fechaDT.day}/$month/${fechaDT.year} - ${fechaDT.hour}:${minute}h";
              return PageView(
                onPageChanged: (e) {},
                children: [
                  Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              planList[index].title,
                              style: const TextStyle(fontSize: defaultFontSize * 1.3, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  CarouselSlider(
                                      items: planList[index].photoURLs.map((e) {
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return GestureDetector(
                                              child: SizedBox(
                                                height: MediaQuery.of(context).size.height / 3.3,
                                                child: FittedBox(
                                                  fit: BoxFit.contain,
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          color: const Color(inputBorderColor),
                                                          borderRadius: const BorderRadius.all(Radius.circular(16)),
                                                          border: Border.all(
                                                              color: const Color(darkestBackroundAccent), width: 5)),
                                                      child: Image.network(e, fit: BoxFit.cover)),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      }).toList(),
                                      options: CarouselOptions(height: MediaQuery.of(context).size.height / 3.3)),
                                ],
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              fecha,
                              style: const TextStyle(fontSize: defaultFontSize, fontWeight: FontWeight.bold),
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
                                color: Color(darkerBackgroundAccent),
                                borderRadius: BorderRadius.all(Radius.circular(16))),
                            child: Text(
                              planList[index].desc,
                              style: const TextStyle(fontSize: defaultFontSize),
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
                              backgroundColor: const Color(accentColor),
                              onPressed: () {},
                              label: const Text("Enviar solicitud"),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
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
