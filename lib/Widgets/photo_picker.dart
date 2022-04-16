import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../Globals/globals.dart';
import '../Services/singleton.dart';

class PhotoPicker extends StatefulWidget {
  const PhotoPicker({Key? key,required this.photoURL}) : super(key: key);

  final String? photoURL;

  @override
  State<PhotoPicker> createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  final Singleton singleton = Singleton.instance;

  /// ### Pick and upload image to firestore
  ///
  /// Async function that prompts the user to pick an image file from the device
  Future uploadPhoto() async {
    // Await the user input and save the result, can be cancelled to return null
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(type: FileType.image);
    // If picked file is not null
    if (result != null) {
      // Create a File object
      File file = File(result.files.single.path!);
      return file;
    } else {
      // Else return 1 ( User cancelled )
      return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        var photo = await uploadPhoto();
        if (photo != 1) {
          await singleton.storage.uploadProfilePhoto(
              singleton.auth.user!.uid, photo);
          setState(() {});
        }
      },
      child: widget.photoURL == null ?  DottedBorder(
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
                      style: TextStyle(
                          fontSize: defaultFontSize,
                          color: Color(textButtonColor))),
                  Icon(Icons.add_a_photo,
                      size: defaultFontSize * 1.5,
                      color: Color(textButtonColor))
                ],
              ),
            ),
          ),
        ),
      ) : SizedBox(
        height: MediaQuery.of(context).size.height / 3.3,
        child: FittedBox(
          fit: BoxFit.contain,
          child: Container(
            decoration: BoxDecoration(
                color: const Color(inputBorderColor),
                borderRadius: const BorderRadius.all(
                    Radius.circular(999)),
                border: Border.all(
                    color:
                    const Color(darkestBackroundAccent),
                    width: 5)),
            child: CircleAvatar(
              backgroundImage: NetworkImage(widget.photoURL!),
            ),
          ),
        ),
      ),
    );
  }
}
