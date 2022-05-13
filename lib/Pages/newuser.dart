import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:hey_plan/Globals/globals.dart';
import 'package:hey_plan/Widgets/loading_widget.dart';
import 'package:numberpicker/numberpicker.dart';

import '../Services/singleton.dart';

class NewUserPage extends StatefulWidget {
  const NewUserPage({Key? key}) : super(key: key);

  @override
  State<NewUserPage> createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  final Singleton singleton = Singleton.instance;
  final TextEditingController _controllerDisplayName = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerSurname = TextEditingController();
  final LoadingWidget l = LoadingWidget();
  File? profileFoto;
  int age = 18;

  @override
  void initState() {
    _controllerDisplayName.text = singleton.auth.user!.displayName == null ? "" : singleton.auth.user!.displayName!;
    super.initState();
  }

  Future uploadFoto() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.image);

    if (result != null) {
      File file = File(
        result.files.single.path!,
      );
      return file;
    } else {
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: SingleChildScrollView(
                child:
                    Column(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                  /*Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 50,
                          decoration: const BoxDecoration(
                              color:  Color(inputBorderColor),
                              borderRadius: BorderRadius.all(Radius.circular(30))
                          ),
                          child: Center(
                            child: Text("Email: ${singleton.auth.user!.email!}",
                                style:
                                    const TextStyle(fontSize: defaultFontSize,fontWeight: FontWeight.bold)),
                          )),*/
                  photoInterface(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child: TextField(
                        decoration: const InputDecoration(
                            labelText: 'Nombre', labelStyle: TextStyle(color: Color(inputBorderColor))),
                        style: const TextStyle(fontSize: inputFontSize),
                        controller: _controllerDisplayName,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 50,
                      child: TextField(
                        decoration: const InputDecoration(
                            labelText: 'Apellido', labelStyle: TextStyle(color: Color(inputBorderColor))),
                        style: const TextStyle(fontSize: inputFontSize),
                        controller: _controllerSurname,
                      ),
                    ),
                  ),
                  Container(
                    width: 150,
                    height: 175,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(darkestBackroundAccent),
                        ),
                        color: const Color(darkerBackgroundAccent),
                        borderRadius: const BorderRadius.all(Radius.circular(20))),
                    child: Column(
                      children: [
                        const Text(
                          "Edad",
                          style: TextStyle(fontSize: defaultFontSize, fontWeight: FontWeight.bold),
                        ),
                        NumberPicker(
                            haptics: true,
                            minValue: 16,
                            maxValue: 120,
                            value: age,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.black87),
                            ),
                            onChanged: (e) {
                              setState(() {
                                age = e;
                              });
                            }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      height: 100,
                      child: TextField(
                        maxLines: 7,
                        decoration: const InputDecoration(
                            labelText: 'Sobre tí', labelStyle: TextStyle(color: Color(inputBorderColor))),
                        style: const TextStyle(fontSize: inputFontSize),
                        controller: _controllerDescription,
                      ),
                    ),
                  ),
                  tagSelector(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.52,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () async {
                            if (_controllerDisplayName.text != '' && _controllerDescription.text != '') {
                              l.showLoadingWidget(context, 'Creando perfil...');
                              await singleton.auth
                                  .updateDisplayName(_controllerDisplayName.text); // Add display name to user data

                              await singleton.storage.uploadProfilePhoto(singleton.auth.user!.uid,
                                  profileFoto!); // Upload photo to firebase storage with user uid

                              await singleton.db.addProfileData(
                                  _controllerSurname.text,
                                  age,
                                  singleton.auth.user!.displayName!,
                                  singleton.auth.user!.uid,
                                  _controllerDescription.text,
                                  []); //  Add description and tag id list to firebase database with user uid
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/scaffold');
                            } else {
                              showDialog(context: context, builder: (BuildContext context) => fieldMissingDialog());
                            }
                          },
                          child: const Text("Crear Perfil")),
                    ),
                  )
                ]),
              ),
            )));
  }

  AlertDialog fieldMissingDialog() {
    String result = "";
    if (_controllerDisplayName.text == '') {
      result = "Por favor escribe tu nombre";
    } else if (_controllerDescription.text == '') {
      result = "Escribe una corta descripción";
    }
    return AlertDialog(
      title: Text(result),
    );
  }

  Widget tagSelector() {
    return Tags();
  }

  Widget photoInterface() {
    return GestureDetector(
      onTap: () async {
        var results = await uploadFoto();
        if (results != 1) {
          setState(() {
            profileFoto = results;
          });
        }
      },
      child: profileFoto == null
          ? DottedBorder(
              strokeWidth: 2,
              dashPattern: const [11, 11],
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                height: MediaQuery.of(context).size.width * 0.5,
                child: Center(
                  child: SizedBox(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Subir foto de perfil",
                            style: TextStyle(fontSize: defaultFontSize, color: Color(textButtonColor))),
                        Icon(Icons.add_a_photo, size: defaultFontSize * 1.5, color: Color(textButtonColor))
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.width * 0.6,
              decoration: BoxDecoration(
                  color: const Color(inputBorderColor),
                  borderRadius: const BorderRadius.all(Radius.circular(999)),
                  border: Border.all(color: const Color(darkerBackgroundAccent), width: 30)),
              child: FittedBox(
                  fit: BoxFit.cover,
                  clipBehavior: Clip.antiAlias,
                  child: CircleAvatar(
                    backgroundImage: FileImage(profileFoto!),
                  ))),
    );
  }
}
