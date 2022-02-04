import 'package:flutter/material.dart';
import 'package:hey_plan/Pages/addplan.dart';
import 'package:hey_plan/Pages/explore.dart';
import 'package:hey_plan/Pages/plans.dart';
import 'package:hey_plan/Services/fire_auth.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late Widget body;
  int currentIndex = 0;
  final AuthService auth = AuthService();

  static const List<Widget> _pages = <Widget>[
    ExplorePage(),
    AddPlanPage(),
    PlansPage(),
  ];

  void onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("REGISTRARSE", style: TextStyle(fontSize: 40)),
            ElevatedButton(
                onPressed: () {},
                child: const Text("Con email i contrassenya")),
            InkWell(
              onTap: () async {
                await auth.signInWithGoogle();
              },
              child: Ink(
                color: const Color(0xFF397AF3),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: const [
                      Icon(Icons.android),
                      SizedBox(width: 12),
                      Text('Entrar con Google'),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}



// Scaffold(
//       body: _pages[currentIndex],
//       appBar: AppBar(
//         backgroundColor: Colors.black12,
//         elevation: 0,
//         toolbarHeight: 30,
//         actions: [
//           SizedBox(
//             width: 30,
//             height: 30,
//             child: IconButton(
//               onPressed: () {
//                 Navigator.pushNamed(context, '/profile');
//               },
//               icon: const Icon(Icons.person),
//             ),
//           ),
//           Container(
//             width: 20,
//           )
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         items: const [
//           BottomNavigationBarItem(
//             icon: Icon(Icons.explore),
//             label: 'Explorar',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.add_circle),
//             label: 'Nuevo Plan',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.list),
//             label: 'Mis planes',
//           ),
//         ],
//         currentIndex: currentIndex,
//         onTap: onTapped,
//       ),
//     );