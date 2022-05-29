import 'package:hey_plan/Models/profile_model.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hey_plan/Globals/globals.dart';
import 'package:hey_plan/Services/singleton.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.chatUID, required this.chatUsers}) : super(key: key);

  final String chatUID;
  final List<String> chatUsers;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Singleton singleton = Singleton.instance;
  final TextEditingController _messageController = TextEditingController();
  late List<ProfileModel> usersData = [];

  Future getUsersData(List<String> users) async {
    List<ProfileModel> usersData = [];
    for (String user in users) {
      var data = await singleton.db.getProfileData(user);
      usersData.add(data);
    }
    setState(() {
      this.usersData = usersData;
    });
  }

  String getUserImage(String userUID) {
    try {
      return usersData.firstWhere((user) => user.uid == userUID).photoURL ?? "";
    } catch (e) {
      return "";
    }
  }

  @override
  void initState() {
    getUsersData(widget.chatUsers);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: singleton.db.chatStream(widget.chatUID),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            Map<String, dynamic> chatData = snapshot.data!.data() as Map<String, dynamic>;
            return Scaffold(
              appBar: AppBar(
                title: Text(chatData['users'][0] ?? ""),
              ),
              body: Center(
                child: Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: chatData['messages'] != null
                            ? ListView.builder(
                                itemCount: chatData['messages'].length,
                                itemBuilder: (BuildContext context, int index) {
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(getUserImage(chatData['messages'][index]['user'])),
                                    ),
                                    title: Text(chatData['messages'][index]['message']),
                                    subtitle:
                                        Text(DateFormat("hh:mm").format(chatData['messages'][index]['date'].toDate())),
                                  );
                                },
                              )
                            : SizedBox(
                                height: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.question_answer_rounded,
                                      size: 100,
                                      color: Color(inputBorderColor),
                                    ),
                                    Text("Envía un mensaje",
                                        style: TextStyle(fontSize: defaultFontSize, color: Color(inputBorderColor))),
                                  ],
                                ),
                              ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _messageController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Escribe algo...",
                                  labelStyle: TextStyle(color: Color(inputBorderColor)),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                              child: CircleAvatar(
                                radius: 30,
                                backgroundColor: const Color(accentColor),
                                child: IconButton(
                                  iconSize: 35,
                                  splashColor: Colors.white,
                                  icon: const Icon(Icons.send_rounded),
                                  color: Colors.white,
                                  onPressed: () async {
                                    if (_messageController.text != "") {
                                      await singleton.db.sendMessage(
                                          widget.chatUID, singleton.auth.user!.uid, _messageController.text);
                                      setState(() {
                                        _messageController.text = "";
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
