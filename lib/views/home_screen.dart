import 'package:roam_assist/constants.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:roam_assist/models/coordinates.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:roam_assist/navigation.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _isListening = false;
  SpeechToText _speech = SpeechToText();
  String text = "";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column (
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Row(
              children: [
                const Icon(Icons.account_circle_outlined, size: 40, color: Colors.black),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Welcome!", style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: Colors.black)),
                    Text("User", style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.menu_outlined, size: 30, color: Colors.black)
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 212, 211, 211),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text("Unitree Go 1", style: TextStyle(fontFamily: 'Poppins', fontSize: 20, color: Colors.black)),
                const Spacer(),
                Text("Offline", style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: Colors.black)),
                // draw a circle here
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                )
              ],
            ),
          ),


        ],
      ),

      floatingActionButton: AvatarGlow(
        animate: _isListening,
        glowColor: Theme.of(context).primaryColor,
        endRadius: 40.0,
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
                      print(text);
                    }),
                  );
                });
              }
            }
          },
          onTapUp: (details) {
            setState(() {
              _isListening = false;
              print("Text before: " + text);
              text="";
              print("Text after: " + text);
              
            });
            _speech.stop();
          },
          child: CircleAvatar(
            backgroundColor: kPrimaryColor,
            radius: 30,
            child: Icon(_isListening ? Icons.mic : Icons.mic_none, size: 40, color: Colors.black,),
          ),
          
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        
        color: Colors.black,
        notchMargin: 10,
        child: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                },
                icon: const Icon(Icons.volume_up_outlined, color: Colors.white,),
              ),
              SizedBox(width: 50,),
              IconButton(
                onPressed: () {
                  Navigation navigate = Navigation();
                  navigate.getRoute(Coordinates(latitude: 1.2946900584496173, longitude: 103.77341260752276), Coordinates(latitude: 1.2948466915714363, longitude: 103.77367303592946));
                  Navigator.pushNamed(context, 'splash_screen');
                },
                icon: const Icon(Icons.power_settings_new, color: Colors.white,),
              ),

            ],
          ),
        ),
      )
    );
  }
}