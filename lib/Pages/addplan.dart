import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hey_plan/Models/profile_model.dart';
import 'package:hey_plan/Models/tag_model.dart';
import 'package:hey_plan/Widgets/tag_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:dotted_border/dotted_border.dart';
import 'dart:io';

import '../Globals/globals.dart';
import '../Services/singleton.dart';

class AddPlanPage extends StatefulWidget {
  const AddPlanPage({Key? key}) : super(key: key);

  @override
  State<AddPlanPage> createState() => _AddPlanPageState();
}

class _AddPlanPageState extends State<AddPlanPage> {
  final Singleton singleton = Singleton.instance;
  final TextEditingController _controllerTitlePlan = TextEditingController();
  bool private = true;
  DateTime? date;
  TimeOfDay? time;
  List<File> photos = [];
  late List<TagModel> tags = [];

  // --- FUNCTIONS --- //

  Future createPlan() async {
    var uuid = const Uuid();
    DateTime formattedDateTime = DateTime.now();
    if (date != null && time != null) {
      formattedDateTime = DateTime(date!.year, date!.month, date!.day, time!.hour, time!.minute);
    }

    var timeUuid = uuid.v1();
    List<String> photoURLs = await singleton.storage.uploadPlanPhotos(timeUuid, photos);
    if (_controllerTitlePlan.text != "") {
      return await singleton.db.createNewPlan(
          _controllerTitlePlan.text, timeUuid, [singleton.auth.user!.uid], formattedDateTime, photoURLs, private);
    }
  }

  Future<List<TagModel>> getTags() async {
    var allTags = await singleton.db.getTags();
    return allTags;
  }

  void resetValues() {
    _controllerTitlePlan.text = "";
    photos = [];
    date = null;
    time = null;
    private = true;
    setState(() {});
  }

  Future pickPhotos() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true, type: FileType.image);
      if (result != null) {
        for (var path in result.paths) {
          photos.add(File(path!));
        }
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  void onConfirmTagSelect(o) {
    List<TagModel?> select = o as List<TagModel?>;
    if (select != []) {
      for (var tag in select) {
        if (!tags.contains(tag)) {
          tags.add(tag!);
        }
      }
    }
    setState(() {});
  }

  Future onDeleteTagPress(List<TagModel> tagsSelected) async {
    for (var tag in tagsSelected) {
      tags.remove(tag);
    }
    setState(() {});
  }

  // --- WIDGETS --- //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.width / 2,
                    child: const CircularProgressIndicator(),
                  ),
                );
              });
          var result = await createPlan();
          resetValues();
          Navigator.pop(context);
          print(result);
        },
        label: const Text("Crear"),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: FutureBuilder<List>(
        future: getTags().timeout(const Duration(seconds: 10)),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          // List of widgets that the future will show when finished
          List<Widget> children;
          // If the results from the future are correct
          if (snapshot.hasData) {
            children = <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: MediaQuery.of(context).size.width,
                      minHeight: MediaQuery.of(context).size.height * 0.7,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          photoPicker(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width / 1.25,
                              child: TextField(
                                controller: _controllerTitlePlan,
                                textAlign: TextAlign.center,
                                autofocus: false,
                              ),
                            ),
                          ),
                          //ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.add_location_rounded), label: const Text("Ubicación")),
                          //Date and time pickers
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton.icon(
                                    onPressed: () async {
                                      var dateResult = await showDatePicker(
                                        context: context,
                                        builder: (context, child) {
                                          return Theme(
                                            child: child!,
                                            data: Theme.of(context).copyWith(
                                                colorScheme: const ColorScheme.light(
                                              primary: Color(accentColor),
                                            )),
                                          );
                                        },
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime.now().add(
                                          const Duration(days: 365), //ss
                                        ),
                                      );
                                      date = dateResult;
                                      print(dateResult);
                                    },
                                    icon: const Icon(Icons.calendar_today),
                                    label: const Text("Dia")),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton.icon(
                                    onPressed: () async {
                                      var timeResult = await showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.now(),
                                        builder: (context, child) {
                                          return Theme(
                                            child: child!,
                                            data: Theme.of(context).copyWith(
                                                colorScheme: const ColorScheme.light(
                                              primary: Color(accentColor),
                                            )),
                                          );
                                        },
                                      );
                                      time = timeResult;
                                      print(timeResult);
                                    },
                                    icon: const Icon(Icons.calendar_today),
                                    label: const Text("Hora")),
                              ),
                            ],
                          ),
                          // People in the plan as circle avatars
                          TagPicker(
                              profileTags: tags,
                              tags: snapshot.data!.map((e) => TagModel(e.uid, e.name)).toList(),
                              onConfirmTagSelect: onConfirmTagSelect,
                              onDeleteTagPress: onDeleteTagPress),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.75,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                avatarWidget(),
                                avatarWidget(),
                                avatarWidget(),
                                avatarWidget(),
                              ],
                            ),
                          ),
                          // Privacy switch for the plan
                          Switch(
                              value: private,
                              onChanged: (a) {
                                setState(() {
                                  private = a;
                                });
                              })
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ];
          }
          // If the result from the future has an error
          else if (snapshot.hasError) {
            if (kDebugMode) {
              print("Snapshot Error: ${snapshot.error}");
            }
            children = <Widget>[Container()];
          }
          // If the result from the future still isnt correct or has an error
          else {
            children = const <Widget>[
              SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Preparando...'),
              )
            ];
          }
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: children,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget customDialog(File item) {
    const padding = 16.0;
    const avatarRadius = 33.0;
    return Dialog(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.transparent,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.only(top: padding, left: padding, bottom: padding + avatarRadius, right: padding),
            margin: const EdgeInsets.only(bottom: avatarRadius),
            decoration:
                const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(padding))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                    onPressed: () async {
                      await pickPhotos();
                      Navigator.pop(context);
                    },
                    child: const Text("Añadir foto", style: TextStyle(fontSize: defaultFontSize))),
                TextButton(
                  onPressed: () {
                    photos.remove(item);
                    setState(() {});
                    Navigator.pop(context);
                  },
                  child: const Text("Eliminar foto", style: TextStyle(fontSize: defaultFontSize)),
                ),
              ],
            ),
          ),
          Positioned(
            right: padding,
            left: padding,
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const CircleAvatar(
                  backgroundColor: Color(accentColor),
                  radius: avatarRadius,
                  child: Icon(
                    Icons.close,
                    size: 30,
                    color: Colors.black,
                  )),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget photoPicker() {
    return photos.isEmpty
        ? GestureDetector(
            onTap: () async {
              await pickPhotos();
            },
            child: DottedBorder(
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
                        Text("Subir foto", style: TextStyle(fontSize: defaultFontSize, color: Color(textButtonColor))),
                        Icon(Icons.add_a_photo, size: defaultFontSize * 1.5, color: Color(textButtonColor))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        : Stack(
            alignment: Alignment.center,
            children: [
              CarouselSlider(
                  items: photos.map((e) {
                    return Builder(
                      builder: (BuildContext context) {
                        return GestureDetector(
                          onLongPress: () async {
                            await showDialog(
                              context: context,
                              barrierDismissible: true,
                              barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                              barrierColor: Colors.transparent,
                              builder: (BuildContext context) => customDialog(e),
                            );
                          },
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height / 3.3,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: const Color(inputBorderColor),
                                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                                      border: Border.all(color: const Color(darkestBackroundAccent), width: 5)),
                                  child: Image.file(e, fit: BoxFit.cover)),
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(height: MediaQuery.of(context).size.height / 3.3)),
            ],
          );
  }

  Widget avatarWidget() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: CircleAvatar(backgroundColor: Colors.grey),
    );
  }
}
