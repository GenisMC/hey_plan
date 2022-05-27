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
  PageController pageController = PageController();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.animateToPage(index, duration: const Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            }),
        title: singleton.auth.user == null ? Container() : Text(singleton.auth.user!.email!),
        actions: [
          IconButton(
              icon: const Icon(Icons.send_rounded),
              onPressed: () {
                Navigator.pushNamed(context, '/messages');
              }),
        ],
      ),
      body: PageView(
        children: const [ExplorePage(), AddPlanPage(), PlansPage()],
        controller: pageController,
        scrollDirection: Axis.horizontal,
        physics: _selectedIndex == 0 ? const NeverScrollableScrollPhysics() : const ScrollPhysics(),
        onPageChanged: (i) {
          setState(() {
            _selectedIndex = i;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Descubrir'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Nuevo Plan'),
          BottomNavigationBarItem(icon: Icon(Icons.folder), label: 'Mis Planes')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(accentColor),
        elevation: 0,
        unselectedItemColor: Colors.white,
        selectedFontSize: defaultFontSize - 2,
        unselectedFontSize: defaultFontSize - 4,
        backgroundColor: const Color(backgroundColor),
        onTap: _onItemTapped,
      ),
    );
  }
}
