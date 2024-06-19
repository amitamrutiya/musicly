import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

Future<void> uploadData() async {
  // Step 1: Parse the JSON file
  String jsonString = await rootBundle.loadString('assets/data.json');
  List<dynamic> jsonData = await jsonDecode(jsonString);

  for (var element in jsonData) {
    element['songs'] = element['songs'].map((e) {
      e['submitedAt'] = DateTime.now();
      return e;
    }).toList();

    FirebaseFirestore.instance
        .collection('singers')
        .doc(element['name'])
        .set(element)
        .then((_) {
      print('Upload successful!');
    }).catchError((error) {
      print('Upload failed: $error');
    });
  }
}
