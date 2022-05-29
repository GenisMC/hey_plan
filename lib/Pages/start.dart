import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hey_plan/Pages/scaffold.dart';
import 'package:hey_plan/Services/singleton.dart';
import 'package:hey_plan/Globals/globals.dart';

import '../Widgets/register_error.dart';

class StartPage extends StatefulWidget {
  const StartPage({Key? key}) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final Singleton singleton = Singleton.instance;

  @override
  Widget build(BuildContext context) {
    return singleton.auth.user == null
        ? Scaffold(
            backgroundColor: const Color(backgroundColor),
            body: Center(
              child: Material(
                elevation: 5,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.4,
                  decoration: const BoxDecoration(
                    color: Color(darkerBackgroundAccent),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("ENTRAR", style: GoogleFonts.fredokaOne(fontSize: defaultFontSize * 2)),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(fixedSize: const Size(215, 55)),
                            onPressed: () {
                              Navigator.pushNamed(context, '/signin');
                            },
                            child: FittedBox(
                                child: Text("Con email i contraseña",
                                    style: GoogleFonts.farro(fontSize: defaultFontSize)))),
                        InkWell(
                          onTap: () async {
                            var result = await singleton.auth.signInWithGoogle();
                            if (result != null) {
                              if (result.additionalUserInfo!.isNewUser == true) {
                                Navigator.pushNamed(context, '/newuser');
                              }
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) =>
                                      const RegisterErrorDialog(response: "Error al iniciar el servicio de Google"));
                            }
                            setState(() {});
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xFF5287cc),
                                borderRadius: const BorderRadius.all(Radius.circular(5)),
                                border: Border.all(color: Colors.grey, width: 1)),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const Icon(Icons.android, size: defaultFontSize * 2),
                                  FittedBox(
                                    child:
                                        Text('Entrar con Google', style: GoogleFonts.farro(fontSize: defaultFontSize)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : const ScaffoldPage();
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
