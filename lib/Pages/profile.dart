import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hey_plan/Models/profile_model.dart';
import 'package:hey_plan/Services/singleton.dart';

import '../Globals/globals.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final Singleton singleton = Singleton.instance;
  final TextEditingController _controllerDesc = TextEditingController();
  bool editing = false;
  String? profilePhoto;

  Future<ProfileModel> getProfile() async {
    String imageURL =
        await singleton.storage.getImageUrl(singleton.auth.user!.uid);
    var profileDoc =
        await singleton.db.getProfileData(singleton.auth.user!.uid);
    _controllerDesc.text = profileDoc['desc'];
    return ProfileModel(
        singleton.auth.user!.uid,
        singleton.auth.user!.displayName!,
        singleton.auth.user!.email!,
        profileDoc['desc'],
        imageURL,
        profileDoc['tags']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Perfil",
          style: GoogleFonts.fredokaOne(fontSize: 30),
        ),
      ),
      floatingActionButton: editing
          ? FloatingActionButton(
              child: const Icon(Icons.save),
              onPressed: () async {
                await singleton.db.editDescription(singleton.auth.user!.uid, _controllerDesc.text);
                setState(() {
                  editing = false;
                });
              })
          : Container(),
      body: FutureBuilder<ProfileModel>(
        future: getProfile(), // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<ProfileModel> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              imageRowWidget(snapshot.data!),
              descriptionWidget(snapshot.data!.description),
              tagsPickerWidget(snapshot.data!.tags),
              exitButton(),
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
          return SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: children,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget descriptionWidget(String description) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: editing
          ? SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.height / 5,
              child: TextField(
                  controller: _controllerDesc,
                  maxLines: 7,
                  expands: false,
                  decoration: const InputDecoration(
                      fillColor: Color(inputBorderColor))))
          : GestureDetector(
              onTap: () {
                setState(() {
                  editing = true;
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                height: MediaQuery.of(context).size.height / 5,
                child: Center(
                    child: Text(
                  description,
                  textAlign: TextAlign.center,
                  maxLines: 7,
                  style: GoogleFonts.amaranth(fontSize: defaultFontSize),
                )),
                decoration: BoxDecoration(
                    color: const Color(inputBorderColor),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: Colors.grey, width: 1)),
              ),
            ),
    );
  }

  Widget imageRowWidget(ProfileModel data) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4,
        decoration: BoxDecoration(color: Colors.grey[300]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: data.photoURL == null
                    ? SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: const CircularProgressIndicator())
                    : SizedBox(
                        height: MediaQuery.of(context).size.height / 3.3,
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(inputBorderColor),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(999)),
                                border:
                                    Border.all(color: Colors.grey, width: 5)),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(data.photoURL!),
                            ),
                          ),
                        ),
                      ),
                flex: 3,
              ),
              Expanded(
                child: Text(
                  singleton.auth.user!.displayName!,
                  style: GoogleFonts.fredokaOne(fontSize: defaultFontSize),
                ),
                flex: 1,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget exitButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: FittedBox(
        child: TextButton.icon(
            onPressed: () async {
              await singleton.auth.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
            style: TextButton.styleFrom(
                primary: Colors.red,
                elevation: 1,
                padding: const EdgeInsets.all(15),
                backgroundColor: const Color(lighterBackgroundAccent),
                textStyle: GoogleFonts.farro(fontSize: defaultFontSize)),
            label: const Text("Salir"),
            icon: const Icon(Icons.logout)),
      ),
    );
  }

  Widget tagsPickerWidget(List<dynamic> tags) {

    removetag(String tag) async {
      await singleton.db.removeTagFromProfile(singleton.auth.user!.uid, tag.split(','));
      setState(() {});
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      child: SizedBox(
        child: Center(
          child: Tags(
              textField: TagsTextField(onSubmitted: (String s) async {
                await singleton.db.addTagToProfile(singleton.auth.user!.uid, s.split(','));
                setState(() {});
              },hintText:  'Añade gustos separados por comas',width: MediaQuery.of(context).size.width * 0.8,autofocus: false),
              itemCount: tags.length,
              itemBuilder: (int index) {
                final tag = tags[index];
                return ItemTags(
                  index: index,
                  key: Key(index.toString()),
                  title: tag,
                  textStyle: GoogleFonts.farro(fontSize: defaultFontSize * 0.8),
                  removeButton: ItemTagsRemoveButton(
                    onRemoved: () {
                      removetag(tag);
                      return true;
                    },
                  ),
                );
              }),
        ),
      ),
    );
  }
}
