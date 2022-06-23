import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

class JsonReader {}

String readJson(String name) => File('assets/jsons/$name').readAsStringSync();

Future<String> getJson(String name) async {
  final str = await rootBundle.loadString('assets/jsons/$name');
  return str;
}

Future<String> loadFromAsset(String name) async {
  return await rootBundle.loadString("assets/jsons/$name");
}
