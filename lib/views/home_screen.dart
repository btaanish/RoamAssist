import 'package:roam_assist/constants.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isListening = false;
  SpeechToText _speech = SpeechToText();
  String text = "";
  String textFunc(String s) {
    print(s);
    if (s == "stand" ||
        s == "stand up" ||
        s == "could you stand" ||
        s == "please stand") {
      print("stand functionality invoked");
    } else if (s == "sit" ||
        s == "sit down" ||
        s == "could you sit" ||
        s == "please sit") {
      print("Sitting functionality invoked");
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column(
        children: [
          //create a rectangular backgrund with broder radius
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            decoration: const BoxDecoration(
              // add color gradient background
              color: kSecondaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Roam Assist",
                    style: TextStyle(
                        fontSize: 50.0,
                        color: kTextColor,
                        fontFamily: 'Poppins'),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 30.0)),
                  GestureDetector(
                      onTap: () {},
                      child: Image.asset(
                        'assets/images/start.png',
                        height: 50,
                        width: 50,
                      ))
                ],
              ),
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                margin: const EdgeInsets.all(30),
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: kTextColor,
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () async {},
                    child: const Text(
                      'Stand',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(30),
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.05,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  color: kTextColor,
                ),
                child: Center(
                  child: TextButton(
                    onPressed: () async {},
                    child: const Text(
                      'Sit',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
          Container(
            child: Text(
              textFunc(text),
             ),
          )
        ],
      ),
      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 75.0,
        duration: const Duration(milliseconds: 2000),
        repeatPauseDuration: const Duration(milliseconds: 100),
        repeat: true,
        child: GestureDetector(
          onTapDown: (details) async {
            if (!_isListening) {
              bool availability = await _speech.initialize();
              if (availability == true) {
                setState(() {
                  _isListening = true;
                  _speech.listen(
                    onResult: (val) => setState(() {
                      text = val.recognizedWords;
                    }),
                  );
                });
              }
            }
          },
          onTapUp: (details) {
            setState(() {
              _isListening = false;
            });
            _speech.stop();
          },
          child: CircleAvatar(
            backgroundColor: kPrimaryColor,
            radius: 30,
            child: Icon(_isListening ? Icons.mic : Icons.mic_none),
          ),
        ),
      ),
    );
  }
}
