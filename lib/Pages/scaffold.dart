import 'package:flutter/material.dart';
import 'package:hey_plan/Pages/addplan.dart';
import 'package:hey_plan/Services/singleton.dart';

class ScaffoldPage extends StatefulWidget {
  ScaffoldPage({Key? key}) : super(key: key);

  @override
  State<ScaffoldPage> createState() => _ScaffoldPageState();
}

class _ScaffoldPageState extends State<ScaffoldPage> {
  final Singleton singleton = Singleton.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(singleton.auth.user!.displayName!),
        actions: [
          IconButton(
              onPressed: () async {
                await singleton.auth.logout();
                setState(() {});
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: const AddPlanPage(),
    );
  }
}
