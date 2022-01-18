import 'package:flutter/material.dart';
import 'package:hey_plan/Pages/addplan.dart';
import 'package:hey_plan/Pages/explore.dart';
import 'package:hey_plan/Pages/plans.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late Widget body;

  @override
  void initState() {
    super.initState();
    body = const ExplorePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      appBar: AppBar(
        backgroundColor: Colors.black12,
        elevation: 0,
        toolbarHeight: 30,
        actions: [
          SizedBox(
            width: 30,
            height: 30,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person),
            ),
          ),
          Container(
            width: 20,
          )
        ],
      ),
      bottomNavigationBar: Stack(
        children: [
          Positioned(
            child: Container(
                height: 50,
                width: 50,
                color: Colors.black12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                        onPressed: () {
                          setState(() {
                            body = const ExplorePage();
                          });
                        },
                        icon: const Icon(Icons.explore_rounded)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            body = const AddPlanPage();
                          });
                        },
                        icon: const Icon(Icons.add)),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            body = const PlansPage();
                          });
                        },
                        icon: const Icon(Icons.auto_awesome_motion)),
                  ],
                )),
            bottom: 0,
            left: 0,
            right: 0,
          )
        ],
      ),
    );
  }
}
