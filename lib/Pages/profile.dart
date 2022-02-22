import 'package:flutter/material.dart';
import 'package:hey_plan/Services/singleton.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final Singleton s = Singleton.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 5,
          decoration: BoxDecoration(color: Colors.grey[300]),
          child: Row(
            children: [
              Image.network("https://ps.w.org/profile-builder/assets/banner-1544x500.png"),
              s.auth.user == null ? Container() : Text(s.auth.user!.displayName!)
            ],
          ),
        ),
      ],
    );
  }
}
