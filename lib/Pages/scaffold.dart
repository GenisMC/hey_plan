import 'package:flutter/material.dart';
import 'package:hey_plan/Globals/globals.dart';
import 'package:hey_plan/Pages/addplan.dart';
import 'package:hey_plan/Pages/explore.dart';
import 'package:hey_plan/Pages/plans.dart';
import 'package:hey_plan/Services/singleton.dart';

class ScaffoldPage extends StatefulWidget {
  const ScaffoldPage({Key? key}) : super(key: key);

  @override
  State<ScaffoldPage> createState() => _ScaffoldPageState();
}

class _ScaffoldPageState extends State<ScaffoldPage> {
  final Singleton singleton = Singleton.instance;
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    ExplorePage(),
    AddPlanPage(),
    PlansPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(icon: const Icon(Icons.person),onPressed: (){
          Navigator.pushNamed(context, '/profile');
        }),
        title: singleton.auth.user == null
            ? Container()
            : Text(singleton.auth.user!.email!),
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore),label: 'Descubrir'),
          BottomNavigationBarItem(icon: Icon(Icons.add),label: 'Nuevo Plan'),
          BottomNavigationBarItem(icon: Icon(Icons.folder),label: 'Mis Planes')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:  Colors.orange,
        onTap: _onItemTapped,
      ),
    );
  }
}
