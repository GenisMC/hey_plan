import 'package:flutter/material.dart';
import 'package:hey_plan/Globals/globals.dart';
import 'package:hey_plan/Models/plan_model.dart';
import 'package:hey_plan/Services/singleton.dart';
import 'package:intl/intl.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({Key? key}) : super(key: key);

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  final Singleton singleton = Singleton.instance;
  Future getPlansDB() async {
    return await singleton.db.getPlans();
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
                "Loading...",
                style: TextStyle(fontSize: defaultFontSize),
              )),
            );
          } else if (snapshot.hasError) {
            return const SizedBox(
              child: Center(child: Text("Error")),
            );
          } else {
            List<PlanModel> plans = snapshot.data as List<PlanModel>;
            return ListView.builder(
              itemBuilder: (BuildContext context, index) {
                return ListTile(
                  title: SizedBox(
                    height: MediaQuery.of(context).size.height / 3,
                    child: GestureDetector(
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return customDialog();
                            });
                      },
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

  Widget customDialog() {
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
            decoration:
                const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(padding))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () async {
                      Navigator.pop(context);
                    },
                    child: const Text("Añadir foto", style: TextStyle(fontSize: defaultFontSize))),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Eliminar foto", style: TextStyle(fontSize: defaultFontSize)),
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
