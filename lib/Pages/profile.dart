import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hey_plan/Services/singleton.dart';

import '../Globals/globals.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Singleton singleton = Singleton.instance;
  String? profilePhoto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: Text("Perfil",style: GoogleFonts.fredokaOne(fontSize: 30),),),
      body: FutureBuilder<String>(
        future: singleton.storage.getImageUrl(singleton
            .auth.user!.uid), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(color: Colors.grey[300]),
                child: Row(
                  children: [
                    Expanded(
                      child: snapshot.data == ''
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                  "https://ps.w.org/profile-builder/assets/banner-1544x500.png"),
                            )
                          : FittedBox(
                              fit: BoxFit.contain,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: const Color(inputBorderColor),
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(999)),
                                    border: Border.all(
                                        color: Colors.grey, width: 5)),
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(snapshot.data!),
                                ),
                              ),
                            ),
                      flex: 5,
                    ),
                    Expanded(
                      child: singleton.auth.user!.displayName == null
                          ? Container()
                          : Text(
                              singleton.auth.user!.displayName!,
                              style: GoogleFonts.fredokaOne(
                                  fontSize: defaultFontSize),
                            ),
                      flex: 1,
                    )
                  ],
                ),
              ),
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
