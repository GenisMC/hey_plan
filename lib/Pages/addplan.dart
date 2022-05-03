import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
  bool private = true;
  DateTime? date;
  TimeOfDay? time;
  List<File> photos = [];

  // --- FUNCTIONS --- //

  Future createPlan() async {
    var uuid = const Uuid();
    DateTime formattedDateTime = DateTime.now();
    if (date != null && time != null) {
      formattedDateTime = DateTime(date!.year, date!.month, date!.day, time!.hour, time!.minute);
    }

    var timeUuid = uuid.v1();
    List<String> photoURLs = await singleton.storage.uploadPlanPhotos(timeUuid, photos);
    return await singleton.db
        .createNewPlan(timeUuid, [singleton.auth.user!.uid], formattedDateTime, photoURLs, private);
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

  // --- WIDGETS --- //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          var result = await createPlan();
          print(result);
        },
        label: const Text("Crear"),
        icon: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            photoPicker(),
            ElevatedButton.icon(
                onPressed: () {}, icon: const Icon(Icons.add_location_rounded), label: const Text("Ubicación")),
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
    );
  }

  @override
  Widget photoPicker() {
    return GestureDetector(
        onTap: () async {
          await pickPhotos();
        },
        child: photos.isEmpty
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
                          Text("Subir foto",
                              style: TextStyle(fontSize: defaultFontSize, color: Color(textButtonColor))),
                          Icon(Icons.add_a_photo, size: defaultFontSize * 1.5, color: Color(textButtonColor))
                        ],
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
                              onTap: () async {
                                //await pickPhotos();
                              },
                              onLongPress: () async {
                                await showGeneralDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
                                  barrierColor: Colors.transparent,
                                  pageBuilder: (BuildContext context, Animation<double> animation,
                                      Animation<double> secondaryAnimation) {
                                    return Dialog(
                                      elevation: 5,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(100))),
                                        width: MediaQuery.of(context).size.width / 2,
                                        height: MediaQuery.of(context).size.height / 10,
                                        child: Row(
                                          children: [
                                            TextButton.icon(
                                                onPressed: () async {
                                                  await pickPhotos();
                                                },
                                                label: const Text("Añadir foto"),
                                                icon: const Icon(Icons.add, size: 30)),
                                            TextButton.icon(
                                                onPressed: () {},
                                                label: const Text("Eliminar foto"),
                                                icon: const Icon(Icons.delete, size: 30)),
                                          ],
                                          mainAxisAlignment: MainAxisAlignment.center,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: SizedBox(
                                height: MediaQuery.of(context).size.height / 3.3,
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color(inputBorderColor),
                                        borderRadius: const BorderRadius.all(Radius.circular(999)),
                                        border: Border.all(color: const Color(darkestBackroundAccent), width: 5)),
                                    child: CircleAvatar(
                                      backgroundImage: FileImage(e),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList(),
                      options: CarouselOptions(height: MediaQuery.of(context).size.height / 3.3)),
                ],
              ));
  }

  Widget avatarWidget() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: CircleAvatar(backgroundColor: Colors.grey),
    );
  }
}

/*
SizedBox(
height: MediaQuery.of(context).size.height / 3.3,
child: FittedBox(
fit: BoxFit.contain,
child: Container(
decoration: BoxDecoration(
color: const Color(inputBorderColor),
borderRadius: const BorderRadius.all(Radius.circular(999)),
border: Border.all(color: const Color(darkestBackroundAccent), width: 5)),
child: CircleAvatar(
backgroundImage: FileImage(photos.first),
),
),
),
),*/
