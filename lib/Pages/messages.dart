import 'package:flutter/material.dart';
import 'package:hey_plan/Globals/globals.dart';
import 'package:hey_plan/Models/friend_model.dart';
import 'package:hey_plan/Services/singleton.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final Singleton singleton = Singleton.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add_alt_1_rounded),
            onPressed: () {
              showCustomDialog(context);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: singleton.db.getFriendList(singleton.auth.user!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            List<FriendModel> friends = snapshot.data as List<FriendModel>;
            return ListView.builder(
              itemCount: friends.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  trailing: const Icon(
                    Icons.arrow_right_rounded,
                    size: 40,
                  ),
                  onTap: () {
                    Navigator.pushNamed(context, '/chat', arguments: friends[index]);
                  },
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 0),
                    child: Text(friends[index].name),
                  ),
                  leading: CircleAvatar(
                    child: Text(friends[index].avatar),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  void showCustomDialog(BuildContext context) {
    bool submitEnabled = true;

    final TextEditingController _uidController = TextEditingController();

    Future addFriend(String uid) async {
      await singleton.db.addFriend(singleton.auth.user!.uid, uid);
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8),
                        child: Text("Agregar contacto",
                            style: TextStyle(fontSize: defaultFontSize, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            controller: _uidController,
                            onSubmitted: (e) async {
                              submitEnabled = false;
                              await addFriend(e);
                              Navigator.pop(context);
                            },
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: submitEnabled
                                ? ElevatedButton(
                                    onPressed: (() async {
                                      await addFriend(_uidController.text);
                                      Navigator.pop(context);
                                    }),
                                    child: const Text("Aceptar"),
                                    style: ElevatedButton.styleFrom(
                                        primary: const Color(accentColor),
                                        textStyle: const TextStyle(fontSize: defaultFontSize),
                                        onPrimary: Colors.white),
                                  )
                                : ElevatedButton(
                                    onPressed: null,
                                    child: const Text("Aceptar"),
                                    style: ElevatedButton.styleFrom(
                                        primary: const Color(accentColor),
                                        textStyle: const TextStyle(fontSize: defaultFontSize),
                                        onPrimary: Colors.white),
                                  )),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
