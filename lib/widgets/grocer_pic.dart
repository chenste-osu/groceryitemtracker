import 'dart:io';
import 'package:flutter/material.dart';

Widget networkPicture(BuildContext context, String imgurl) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Image.network(imgurl,
        height: 250,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return loadingPicture();
        },
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error)),
  );
}

Widget localPicture(BuildContext context, File? image) {
  if (image == null) {
    return loadingPicture();
  }
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10.0),
    child: Image.file(image,
        height: 250,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error)),
  );
}

Widget loadingPicture() {
  return const Padding(
    padding: EdgeInsets.symmetric(vertical: 10.0),
    child: SizedBox(
        height: 250,
        child: Center(child: CircularProgressIndicator(value: null))),
  );
}
