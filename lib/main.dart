import 'package:flutter/material.dart';
import 'package:hey_plan/Pages/explore.dart';
import 'package:hey_plan/Pages/plans.dart';
import 'package:hey_plan/Pages/profile.dart';
import 'package:hey_plan/Pages/start.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: '/',
      routes: {
        '/': (context) => const StartPage(),
        '/profile': (context) => const ProfilePage(),
        '/plans': (context) => const PlansPage(),
        '/explore': (context) => const ExplorePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
