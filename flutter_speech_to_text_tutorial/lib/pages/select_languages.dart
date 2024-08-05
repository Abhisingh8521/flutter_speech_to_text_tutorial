import 'package:flutter/material.dart';
import 'package:get/get.dart';


class LanguageSelectionScreen extends StatelessWidget {
  final LanguageController languageController = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Color(0xFF648dae),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.image_outlined,
                    size: 100,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'select_language'.tr,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'change_language'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: 240,
                    child: DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                      value: 'English',
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          String languageCode = newValue == 'English' ? 'en' : 'hi';
                          languageController.changeLanguage(languageCode);
                        }
                      },
                      items: <String>['English', 'Hindi']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),


                  MaterialButton(
                    minWidth: 240,
                    height: 50,
                    onPressed: () {

                    },
                    color: const Color(0xFF273c75),
                    textColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),

                    child: Text('next'.tr),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}




class LanguageController extends GetxController {
  void changeLanguage(String languageCode) {
    var locale = Locale(languageCode, '');
    Get.updateLocale(locale);
  }
}




class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'select_language': 'Please select your Language',
      'change_language': 'You can change the language\nat any time.',
      'next': 'NEXT',
    },
    'hi_IN': {
      'select_language': 'कृपया अपनी भाषा चुनें',
      'change_language': 'आप किसी भी समय भाषा बदल सकते हैं।',
      'next': 'आगे',
    },
  };
}
