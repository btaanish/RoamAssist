import 'package:group_button/group_button.dart';
import 'package:roam_assist/constants.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';


import '../conn/client.dart';
import 'coordinates_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

enum Locations { goal1, goal2, goal3, goal4, goal5 }

class _MainScreenState extends State<MainScreen> {
  bool _isListening = false;
  String currentStatus = "Idle";
  SpeechToText _speech = SpeechToText();
  String text = "";
  String textFunc(String s) {
    if (s == "stand" ||
        s == "Stand" ||
        s == "stand up" ||
        s == "Stand up" ||
        s == "could you stand" ||
        s == "please stand") {
      print("stand");
      sendCommand("stand");
      currentStatus = "Standing Idle";
    } else if (s == "sit" ||
        s == "Sit" ||
        s == "sit down" ||
        s == "Sit down" ||
        s == "could you sit" ||
        s == "please sit") {
      print("sit");
      sendCommand("sit");
      currentStatus = "Sitting";
    } else if (s == "start" || s == "Start") {
      //sendCommand("start");
      currentStatus = "Idle";
    }
    return "";
  }

  Locations? _character = Locations.goal1;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column (
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: const Row(
              children: [
                Icon(Icons.account_circle_outlined, size: 40, color: Colors.black),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Welcome!", style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: Colors.black)),
                    Text("User", style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
                Spacer(),
                Icon(Icons.menu_outlined, size: 30, color: Colors.black)
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
                const Text("Unitree Go 1", style: TextStyle(fontFamily: 'Poppins', fontSize: 20, color: Colors.black)),
                const Spacer(),
                const Text("Online", style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: Colors.black)),
                // draw a circle here
                Container(
                  margin: const EdgeInsets.only(left: 5),
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                )
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.only(right: 20, top:20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children:  [
                Icon(Icons.pets_outlined, size: 15, color: Colors.black),
                Text(" $currentStatus", style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: Colors.black)),
              ],
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 0),
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
                    onPressed: () async {
                      sendCommand("stand");
                    },
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
                    onPressed: () async {
                      sendCommand("sit");
                    },
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
          ),

          Container(
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(children: [
              ListTile(
                title: const Text('Position 1'),
                leading: Radio<Locations>(
                  value: Locations.goal1,
                  groupValue: _character,
                  onChanged: (Locations? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Position 2'),
                leading: Radio<Locations>(
                  value: Locations.goal2,
                  groupValue: _character,
                  onChanged: (Locations? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Position 3'),
                leading: Radio<Locations>(
                  value: Locations.goal3,
                  groupValue: _character,
                  onChanged: (Locations? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Position 4'),
                leading: Radio<Locations>(
                  value: Locations.goal4,
                  groupValue: _character,
                  onChanged: (Locations? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
              ListTile(
                title: const Text('Position 5'),
                leading: Radio<Locations>(
                  value: Locations.goal5,
                  groupValue: _character,
                  onChanged: (Locations? value) {
                    setState(() {
                      _character = value;
                    });
                  },
                ),
              ),
            ],),
          ),
          const SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll(Colors.black),
                    alignment: Alignment.center,
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                      )
                    )
                ),
                onPressed: () {
                  currentStatus = "Walking";
                  sendCommand("start_nav");
                  String goal_id = _character.toString().split('.').last;
                  print("Goal ID: $goal_id");
                  sendCommand(goal_id);
                },
                child: const Text(
                  'Start Navigation',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 30,),
              TextButton(
                style: ButtonStyle(
                    backgroundColor: const MaterialStatePropertyAll(Colors.black),
                    alignment: Alignment.center,
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                      )
                    )
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'coordinates_screen');
                },
                child: Text(
                  'Add Coordinates',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),

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
              textFunc(text);
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
                onPressed: () {},
                icon: const Icon(Icons.volume_up_outlined, color: Colors.white,),
              ),
              SizedBox(width: 50,),

              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, 'home_screen');
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