import 'package:flutter/material.dart';
import 'package:hey_plan/Globals/globals.dart';
import 'package:hey_plan/generated/intl/messages_en.dart';

class EmptyMessage extends StatelessWidget {
  const EmptyMessage({Key? key, required this.message}) : super(key: key);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.75,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Icon(
                Icons.question_mark_rounded,
                size: 75,
                color: Colors.grey,
              ),
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: defaultFontSize),
              )
            ],
          ),
        ),
      ),
    );
  }
}
