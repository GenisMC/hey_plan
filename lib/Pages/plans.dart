import 'package:flutter/material.dart';
import 'package:hey_plan/Globals/globals.dart';
import 'package:hey_plan/Models/plan_model.dart';
import 'package:hey_plan/Services/singleton.dart';
import 'package:hey_plan/Widgets/empty_message.dart';
import 'package:hey_plan/Widgets/error_message.dart';
import 'package:intl/intl.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({Key? key}) : super(key: key);

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  final Singleton singleton = Singleton.instance;
  Future getPlansDB() async {
    return await singleton.db.getUserPlans(singleton.auth.user!.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: FutureBuilder(
        future: getPlansDB(),
        builder: ((context, snapshot) {
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
            List<PlanModel> plans = snapshot.data as List<PlanModel>;
            return plans.isEmpty
                ? const EmptyMessage(
                    message:
                        "Parece que aquí no hay nada, crea un plan o ve a describrir para añadir planes a tus favoritos.")
                : ListView.builder(
                    itemBuilder: (BuildContext context, index) {
                      return ListTile(
                        title: GestureDetector(
                          onLongPress: () async {
                            await showDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                              barrierColor: Colors.transparent,
                              builder: (BuildContext context) => customDialog(plans[index]),
                            );
                          },
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height / 3,
                            child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Column(
                                    children: [
                                      Expanded(
                                          child: ClipRRect(
                                              borderRadius: BorderRadius.circular(16),
                                              child: Image.network(plans[index].photoURLs.first))),
                                      Text(
                                        DateFormat.yMMMMEEEEd().format(plans[index].date),
                                        style: const TextStyle(fontSize: defaultFontSize),
                                      ),
                                      Text(plans[index].title, style: const TextStyle(fontSize: defaultFontSize))
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      );
                    },
                    itemCount: plans.length,
                  );
          }
        }),
      ),
    );
  }

  Widget customDialog(PlanModel plan) {
    const padding = 16.0;
    const avatarRadius = 33.0;
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: padding, left: padding, bottom: padding + avatarRadius, right: padding),
            margin: const EdgeInsets.only(bottom: avatarRadius),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(accentColor), width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(padding))),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.warning,
                  color: Colors.red,
                  size: 40,
                ),
                ElevatedButton(
                  onPressed: () async {
                    int value = await singleton.db.removeUserFromPLan(plan.docID, singleton.auth.user!.uid);
                    if (value == 1) {
                      await singleton.storage.deletePlanImages(plan.docID, plan.photoURLs.length);
                    }
                    setState(() {});
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.grey[200], elevation: 5),
                  child: const Text("Salir del plan",
                      style: TextStyle(fontSize: defaultFontSize, color: Colors.red, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
          Positioned(
            right: padding,
            left: padding,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const CircleAvatar(
                  backgroundColor: Color(accentColor),
                  radius: avatarRadius,
                  child: Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.black,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
