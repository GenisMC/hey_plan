import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
              Image.network(
                  "https://ps.w.org/profile-builder/assets/banner-1544x500.png"),
              const Text("Nom Usuari")
            ],
          ),
        ),
      ],
    );
  }
}
