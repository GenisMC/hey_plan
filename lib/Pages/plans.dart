import 'package:flutter/material.dart';
import 'package:hey_plan/Services/singleton.dart';

class PlansPage extends StatefulWidget {
  const PlansPage({Key? key}) : super(key: key);

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  final Singleton singleton = Singleton.instance;
  Future getPlans() async {
    return await singleton.db.getPlans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getPlans(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return Center();
          } else {
            return Container(); //TODO: add error page
          }
        }),
      ),
    );
  }
}
