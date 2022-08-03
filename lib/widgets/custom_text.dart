import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

Widget dateText(String text) {
  return AutoSizeText(text,
      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold));
}

Widget locationText(String text) {
  return AutoSizeText(text, style: const TextStyle(fontSize: 15));
}

Widget descText(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 15.0),
    child: AutoSizeText(text, style: const TextStyle(fontSize: 20)),
  );
}

Widget costText(String text) {
  return Padding(
    padding: const EdgeInsets.only(top: 15.0),
    child: AutoSizeText(text, style: const TextStyle(fontSize: 20)),
  );
}
