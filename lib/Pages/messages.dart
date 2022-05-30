import 'package:flutter/material.dart';
import 'package:hey_plan/Globals/globals.dart';
import 'package:hey_plan/Models/friend_model.dart';
import 'package:hey_plan/Models/profile_model.dart';
import 'package:hey_plan/Pages/chat.dart';
import 'package:hey_plan/Services/singleton.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final Singleton singleton = Singleton.instance;

  Future getChatUsersProfile(String uid) async {
    Map<String, dynamic> data = await singleton.db.getProfileData(uid) as Map<String, dynamic>;
    return ProfileModel(uid, data['name'], "", data['desc'], data['photoURL'], []);
  }

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
                  onTap: () async {
                    String chatID = await singleton.db.checkIfChatExists(singleton.auth.user!.uid, friends[index].id);
                    List<ProfileModel> profiles = [];
                    for (var user in [singleton.auth.user!.uid, friends[index].id]) {
                      profiles.add(await getChatUsersProfile(user));
                    }
                    if (chatID != "") {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatPage(
                                    chatUID: chatID,
                                    chatUsers: profiles,
                                  )));
                    }
                  },
                  title: Padding(
                    padding: const EdgeInsets.fromLTRB(25.0, 0, 0, 0),
                    child: Text(friends[index].name),
                  ),
                  leading: CircleAvatar(
                    child: Container(),
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
    final TextEditingController _uidController = TextEditingController();

    Future addFriend(String uid) async {
      var result = await singleton.db.addFriend(singleton.auth.user!.uid, uid);
      if (result == 1) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Hecho!'),
                content: const Text('Usuario añadido como contacto'),
                actions: [
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      } else if (result == -1) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('El usuario no existe'),
              actions: [
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('El usuario ya esta en tu lista'),
              actions: [
                TextButton(
                  child: const Text('Ok'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          },
        );
      }
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
                            style: TextStyle(fontSize: defaultFontSize * 1.1, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: TextField(
                            controller: _uidController,
                            onSubmitted: (e) async {
                              await addFriend(e);
                            },
                            decoration: InputDecoration(
                              hintText: 'Id única',
                              helperStyle: const TextStyle(fontSize: defaultFontSize * 0.9, color: Colors.black),
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
                              child: ElevatedButton(
                                onPressed: (() async {
                                  await addFriend(_uidController.text);
                                }),
                                child: const Text("Aceptar"),
                                style: ElevatedButton.styleFrom(
                                    primary: const Color(accentColor),
                                    textStyle: const TextStyle(fontSize: defaultFontSize),
                                    onPrimary: Colors.white),
                              )))
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
