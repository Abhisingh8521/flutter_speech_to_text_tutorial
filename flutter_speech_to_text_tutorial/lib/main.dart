import 'package:flutter/material.dart';
import 'package:flutter_speech/pages/select_languages.dart';
import 'package:get/get.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Messages(),
      locale: Locale('en', 'US'),
      fallbackLocale: Locale('en', 'US'),
      home: LanguageSelectionScreen(),
    );
  }
}
