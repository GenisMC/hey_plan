import 'package:hey_plan/Models/profile_model.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hey_plan/Globals/globals.dart';
import 'package:hey_plan/Services/singleton.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key, required this.chatUID, required this.chatUsers}) : super(key: key);

  final String chatUID;
  final List<ProfileModel> chatUsers;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final Singleton singleton = Singleton.instance;
  final TextEditingController _messageController = TextEditingController();
  late ScrollController _scrollController;
  bool scrolled = false;

  String getUserImage(String userUID) {
    try {
      return widget.chatUsers.firstWhere((user) => user.uid == userUID).photoURL ?? "";
    } catch (e) {
      return "";
    }
  }

  void _scrollListener() {
    if (!scrolled) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      scrolled = true;
    }
  }

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);
    _scrollController.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    super.dispose();
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
                centerTitle: true,
                title: Text(widget.chatUsers[0].displayName + " y " + widget.chatUsers[1].displayName),
              ),
              body: Center(
                child: Column(
                  children: [
                    Expanded(
                      child: chatData['messages'] != null
                          ? ListView.builder(
                              controller: _scrollController,
                              shrinkWrap: true,
                              itemCount: chatData['messages'].length,
                              itemBuilder: (BuildContext context, int index) {
                                return messageWidget(chatData, index);
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
                                    String text = _messageController.text;
                                    setState(() {
                                      _messageController.text = "";
                                    });
                                    await singleton.db.sendMessage(widget.chatUID, singleton.auth.user!.uid, text);
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

  Widget messageWidget(Map<String, dynamic> chatData, int index) {
    ProfileModel user = widget.chatUsers.firstWhere((user) => user.uid == chatData['messages'][index]['user']);
    user.uid == singleton.auth.user!.uid ? user.displayName = "Tú" : user.displayName = user.displayName;
    bool isCurrentUser = chatData['messages'][index]['user'] == singleton.auth.user!.uid;
    List<Widget> userMessage = [
      messageDate(isCurrentUser, chatData['messages'][index]['date']),
      const SizedBox(width: 10),
      nameMessageColumn(isCurrentUser, user.displayName, chatData['messages'][index]['message']),
    ];
    List<Widget> otherMessage = [
      circleAvatar(user.uid),
      const SizedBox(width: 10),
      nameMessageColumn(isCurrentUser, user.displayName, chatData['messages'][index]['message']),
      messageDate(isCurrentUser, chatData['messages'][index]['date']),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            width: MediaQuery.of(context).size.width * 0.51,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: isCurrentUser ? Colors.white : const Color(accentColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: isCurrentUser ? userMessage : otherMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget circleAvatar(String userUID) {
    return CircleAvatar(
      backgroundImage: NetworkImage(getUserImage(userUID)),
    );
  }

  Widget nameMessageColumn(bool isCurrentUser, String name, String? message) {
    return Column(
      crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: defaultFontSize - 3,
          ),
          textAlign: isCurrentUser ? TextAlign.end : TextAlign.start,
        ),
        Text(
          message ?? "",
          style: const TextStyle(color: Colors.black, fontSize: defaultFontSize - 4),
          textAlign: isCurrentUser ? TextAlign.end : TextAlign.start,
        ),
      ],
    );
  }

  Widget messageDate(bool isCurrentUser, Timestamp date) {
    return Expanded(
        child: Text(DateFormat.Hm().format(date.toDate()),
            style: TextStyle(color: isCurrentUser ? Colors.black : Colors.white),
            textAlign: isCurrentUser ? TextAlign.start : TextAlign.end));
  }
}
