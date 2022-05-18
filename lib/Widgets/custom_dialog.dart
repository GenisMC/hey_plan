import 'package:flutter/material.dart';
import 'package:hey_plan/Globals/globals.dart';

class CustomDialog {
  void showCustomDialog(BuildContext context, String message) {
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                          height: MediaQuery.of(context).size.width * 0.3,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Icon(
                            Icons.info,
                            size: MediaQuery.of(context).size.width * 0.2,
                            color: Colors.blue[300],
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(message,
                            style: const TextStyle(fontSize: defaultFontSize, fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                              onPressed: (() {
                                Navigator.pop(context);
                              }),
                              child: const Text("Aceptar"),
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.blue,
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
