import 'package:flutter/material.dart';
import 'package:hey_plan/Globals/globals.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: const [
                Icon(
                  Icons.warning_rounded,
                  size: 75,
                  color: Colors.amber,
                ),
                Text(
                  "Error en la base de datos, disculpa las molestias.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: defaultFontSize),
                )
              ],
            ),
          )),
    );
  }
}
