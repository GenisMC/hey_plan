import 'package:flutter/material.dart';
import 'package:hey_plan/Pages/explore.dart';
import 'package:hey_plan/Pages/plans.dart';
import 'package:hey_plan/Pages/profile.dart';
import 'package:hey_plan/Pages/start.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: '/',
      routes: {
        '/': (context) => const StartPage(),
        '/profile': (context) => ProfilePage(),
        '/plans': (context) => const PlansPage(),
        '/explore': (context) => const ExplorePage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
