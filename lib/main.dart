import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';

import 'app.dart';

void main() async {
  await GetStorage.init();
  await dotenv.load(fileName: ".env");
  runApp(const App());
}
