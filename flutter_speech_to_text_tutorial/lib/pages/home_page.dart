import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class TextVoice extends StatefulWidget {
  @override
  _TextVoiceState createState() => _TextVoiceState();
}

class _TextVoiceState extends State<TextVoice> {
  final FlutterTts flutterTts = FlutterTts();
  bool isSpeaking = false;
  late TextEditingController textEditingController;
  late stt.SpeechToText speechToText;
  bool isListening = false;
  bool speechRecognitionAvailable = false;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    speechToText = stt.SpeechToText();

    flutterTts.setStartHandler(() {
      setState(() {
        isSpeaking = true;
      });
    });
    flutterTts.setCompletionHandler(() {
      setState(() {
        isSpeaking = false;
      });
    });

    _initialize();
  }

  Future<void> _initialize() async {
    await _requestPermissions();
    await _initSpeechToText();
  }

  Future<void> _requestPermissions() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
      if (!status.isGranted) {
        print('Microphone permission is required for speech recognition');
        setState(() {
          errorMessage = 'Microphone permission is required for speech recognition';
        });
        return;
      }
    }
  }

  Future<void> _initSpeechToText() async {
    try {
      bool available = await speechToText.initialize(
        onStatus: (val) => print('onStatus: $val'),
        onError: (val) => print('onError: $val'),
      );
      setState(() {
        speechRecognitionAvailable = available;
        if (!available) {
          errorMessage = 'Speech recognition not available on this device';
        }
      });
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
      setState(() {
        speechRecognitionAvailable = false;
        errorMessage = 'Error initializing speech recognition: ${e.message}';
      });
    }
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    await flutterTts.setLanguage("es-MX");
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  Future<void> _stop() async {
    await flutterTts.stop();
  }

  Future<void> _listen() async {
    if (speechRecognitionAvailable) {
      if (!isListening) {
        setState(() => isListening = true);
        speechToText.listen(
          onResult: (val) => setState(() {
            textEditingController.text = val.recognizedWords;
          }),
        );
      } else {
        setState(() => isListening = false);
        speechToText.stop();
      }
    } else {
      print('Speech recognition not available');
      setState(() {
        errorMessage = 'Speech recognition not available';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Text to Speech & Speech to Text"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: textEditingController,
              decoration: InputDecoration(
                labelText: "Enter text or speak",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              isSpeaking ? "Speaking..." : "Not speaking",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: () => _speak(textEditingController.text),
                  child: Icon(Icons.play_arrow),
                ),
                const SizedBox(width: 30),
                FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: _stop,
                  child: const Icon(Icons.stop),
                ),
                const SizedBox(width: 30),
                FloatingActionButton(
                  backgroundColor: Colors.blue,
                  onPressed: _listen,
                  child: Icon(isListening ? Icons.mic : Icons.mic_none),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              speechRecognitionAvailable ? "Speech recognition available" : "Speech recognition not available",
              style: TextStyle(fontSize: 18, color: speechRecognitionAvailable ? Colors.green : Colors.red),
            ),
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}
