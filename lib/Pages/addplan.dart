import 'package:flutter/material.dart';
import 'package:hey_plan/Widgets/photo_picker.dart';
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
  String? photoURL;
  bool private = true;
  DateTime? date;
  TimeOfDay? time;

  Future getPhotoUrl(File photo) async {
    setState(() {
      photoURL = photo.path;
    });
  }

  Future createPlan() async {
    DateTime formattedDateTime = DateTime.now();
    if (date != null && time != null) {
      formattedDateTime = DateTime(date!.year, date!.month, date!.day, time!.hour, time!.minute);
    }
    List<String> photoURLs = [photoURL!];
    return await singleton.db.createNewPlan([singleton.auth.user!.uid], formattedDateTime, photoURLs, private);
  }

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
            const PhotoPicker(photoURL: null),
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
    return Container();
    /*
    return GestureDetector(
      onTap: () async {
        var photo = await uploadPhoto();
        if (photo != 1) {
          setState(() {
            selectedPhoto = photo.path;
          });
        }
      },
      child: finalURL == null
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
                        Text("Subir foto", style: TextStyle(fontSize: defaultFontSize, color: Color(textButtonColor))),
                        Icon(Icons.add_a_photo, size: defaultFontSize * 1.5, color: Color(textButtonColor))
                      ],
                    ),
                  ),
                ),
              ),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height / 3.3,
              child: FittedBox(
                fit: BoxFit.contain,
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(inputBorderColor),
                      borderRadius: const BorderRadius.all(Radius.circular(999)),
                      border: Border.all(color: const Color(darkestBackroundAccent), width: 5)),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(finalURL!),
                  ),
                ),
              ),
            ),
    );
    */
  }

  Widget avatarWidget() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: CircleAvatar(backgroundColor: Colors.grey),
    );
  }
}
