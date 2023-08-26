import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Speech {

  final FlutterTts flutterTts = FlutterTts();
  final TextEditingController textEditingController = TextEditingController();

  speak_start() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.5);
    await flutterTts.speak("start journey");
  }
  speak_turn_left() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.5);
    await flutterTts.speak("turn left");
  }
  speak_turn_right() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.5);
    await flutterTts.speak("turn right");
  }
  speak_walk_straight() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.5);
    await flutterTts.speak("walk straight");
  }

  stop() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setPitch(1.5);
    await flutterTts.speak("Stopping Journey");
  }
}
