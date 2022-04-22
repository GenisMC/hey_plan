import 'package:flutter/material.dart';

class RegisterErrorDialog extends StatelessWidget {
  const RegisterErrorDialog({Key? key,required this.response}) : super(key: key);

  final String response;

  @override
  Widget build(BuildContext context) {
      return AlertDialog(
        title: const Text("Error de registro"),
        content: Text(response),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cerrar"))
        ],
      );
  }
}
