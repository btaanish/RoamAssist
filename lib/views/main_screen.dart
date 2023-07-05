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
  bool _isOnline = false;
  bool _isRunning = false;
  String currentStatus = "Idle";
  SpeechToText _speech = SpeechToText();
  List<String> maps = ["Maps"];
  String? selectedMap = "Maps";
  List<String> locations1 = ["Locations"];
  List<String> locations2 = ["Locations"];
  String? selectedStart = "Locations";
  String? selectedEnd = "Locations";
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
      // sendCommand("start");
      currentStatus = "Idle";
    } else if (s == "go to position one" ||
            s == "please go to position one" ||
            s == "could you go to position one" ||
            s == "I would like to go to position one" ||
            s == "please take make me to position one" ||
            s == "Go to position one" ||
            s == "Please go to position one" ||
            s == "Could you go to position one" ||
            s == "I would like to go to position one" ||
            s == "Please take make me to position one") {
          currentStatus = "Walking";
          sendCommand("start_nav");
          print("Goal ID: 1");
          sendCommand("goal1");
    } else if (s == "go to position 1" ||
        s == "please go to position 1" ||
        s == "could you go to position 1" ||
        s == "I would like to go to position 1" ||
        s == "please take make me to position 1" ||
        s == "Go to position 1" ||
        s == "Please go to position 1" ||
        s == "Could you go to position 1" ||
        s == "I would like to go to position 1" ||
        s == "Please take make me to position 1") {
      // await player.play(AssetSource('sounds/go.wav'));
      currentStatus = "Walking";
      sendCommand("start_nav");
      print("Goal ID: 1");
      sendCommand("goal1");
    } else if (s == "go to position 2" ||
        s == "please go to position 2" ||
        s == "could you go to position 2" ||
        s == "I would like to go to position 2" ||
        s == "please take make me to position 2" ||
        s == "Go to position 2" ||
        s == "Please go to position 2" ||
        s == "Could you go to position 2" ||
        s == "I would like to go to position 2" ||
        s == "Please take make me to position 2") {
      currentStatus = "Walking";
      sendCommand("start_nav");
      print("Goal ID: 2");
      sendCommand("goal2");
    }else if (s == "go to position 3" ||
        s == "please go to position 3" ||
        s == "could you go to position 3" ||
        s == "I would like to go to position 3" ||
        s == "please take make me to position 3" ||
        s == "Go to position 3" ||
        s == "Please go to position 3" ||
        s == "Could you go to position 3" ||
        s == "I would like to go to position 3" ||
        s == "Please take make me to position 3") {
      currentStatus = "Walking";
      sendCommand("start_nav");
      print("Goal ID: 3");
      sendCommand("goal3");
    } else if (s == "go to position 4" ||
        s == "please go to position 4" ||
        s == "could you go to position 4" ||
        s == "I would like to go to position 4" ||
        s == "please take make me to position 4" ||
        s == "Go to position 4" ||
        s == "Please go to position 4" ||
        s == "Could you go to position 4" ||
        s == "I would like to go to position 4" ||
        s == "Please take make me to position 4") {
      currentStatus = "Walking";
      sendCommand("start_nav");
      print("Goal ID: 4");
      sendCommand("goal4");
    } else if (s == "go to position 5" ||
        s == "please go to position 5" ||
        s == "could you go to position 5" ||
        s == "I would like to go to position 5" ||
        s == "please take make me to position 5" ||
        s == "Go to position 5" ||
        s == "Please go to position 5" ||
        s == "Could you go to position 5" ||
        s == "I would like to go to position 5" ||
        s == "Please take make me to position 5") {
      currentStatus = "Walking";
      sendCommand("start_nav");
      print("Goal ID: 5");
      sendCommand("goal5");
    } else if (s == "add coordinates" ||
        s == "please add coordinates" ||
        s == "could you add coordinates" ||
        s == "I would like to add coordinates" ||
        s == "Add coordinates" ||
        s == "Please add coordinates" ||
        s == "Could you add coordinates") {
      Navigator.pushNamed(context, 'coordinates_screen');
    }
    return "";
  }
  List<String> textToList(String s) {
    s = s + ',';
    List<String> wrdList = [];
    String s1 = "";
    for (int  i = 0; i < s.length; i ++) {
      if (s[i] != ",") {
        s1 += s[i];
      } else {
        wrdList.add(s1.trim());
        s1 = "";
      }
    }
    return wrdList;
  }
  Locations? _character = Locations.goal1;
  List<String> textBefColon(String s) {
    List<String> sentences = ["", ""];
    bool flag = false;
    for (int i = 0; i < s.length; i++) {
      if (s[i] == ":") {
        flag = true;
        continue;
      }
      if (!flag) {
        sentences[0] += s[i];
      } else {
        sentences[1] += s[i];
      }
    }
    print(s + " , " + sentences[0] + sentences[1]);
    return sentences;
  }

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
                  Spacer(
                  ),
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

                    _isOnline ? const Text("Online", style: TextStyle(fontFamily: 'Poppins',
                        fontSize: 15,
                        color: Colors.black))
                    : const Text("Offline", style: TextStyle(fontFamily: 'Poppins',
                    fontSize: 15,
                    color: Colors.black)),
                    // draw a circle here
                    _isOnline ? Container(
                      margin: const EdgeInsets.only(left: 5),
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    )
                        : Container(
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
                text,
              ),
            ),


            SizedBox(
              width: 300,
              child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(width: 3, color: Colors.black)
                    )
                  ),
                  items: maps
                  .map((map) => DropdownMenuItem<String>(
                  value: map,
                  child: Text(
                      map,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                  )
                  ))).toList(),
                  value: selectedMap,
                  onChanged: (map) async {
                    String s4 = await sendCommand("get_start_and_goal:" + map.toString());
                    setState(()  {
                    selectedMap = map;
                    List<String> locs = textBefColon(s4);
                    print(locs);
                    locations1 = textToList(locs[0]);
                    selectedStart = locations1[0];
                    locations2 = textToList(locs[1]);
                    selectedEnd = locations2[0];
                  });
                  })
        ),
            const SizedBox(height: 20,),
            SizedBox(
              width: 300,
              child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(width: 3, color: Colors.black)
                      )
                  ),
                  items: locations1
                      .map((location) => DropdownMenuItem<String>(
                      value: location,
                      child: Text(
                          location,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                          )
                      ))).toList(),
                  value: selectedStart,
                  onChanged: (start) => setState(() {
                    selectedStart = start;
                    // print("set_initial_pose:" + selectedStart.toString());
                    sendCommand("set_initial_pose:" + selectedStart.toString());
                  })),
            ),
            const SizedBox(height: 20,),
            SizedBox(
              width: 300,
              child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(width: 3, color: Colors.black)
                      )
                  ),
                  items: locations2
                      .map((location) => DropdownMenuItem<String>(
                      value: location,
                      child: Text(
                          location,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                          )
                      ))).toList(),
                  value: selectedEnd,
                  onChanged: (end) => setState(() {
                    selectedEnd = end;
                    // print("set_goal:" + selectedEnd.toString());
                    sendCommand("set_goal:" + selectedEnd.toString());
                  })),
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
                    sendCommand("start_move");
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
            onTapUp: (details) async {
              setState(() async {
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
                  onPressed: () {
                    if (_isRunning) {
                      sendCommand("pause_move");
                      currentStatus = "Standing Idle";
                    } else {
                      sendCommand("start_move");
                      currentStatus = "Walking";
                    }
                    setState(() {
                      _isRunning = !_isRunning;
                    });
                  },
                  icon: Icon(
                     _isRunning ? Icons.pause : Icons.play_arrow_rounded,
                    color: Colors.white,),
                ),
                SizedBox(width: 50,),

                IconButton(
                  onPressed: () async {
                    //Navigator.pushNamed(context, 'home_screen');
                    String s3 = await sendCommand("start");
                    setState(() {
                      maps = textToList(s3);
                      selectedMap = maps[0];
                      _isOnline = !_isOnline;
                    });
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
// Container(
//   margin: EdgeInsets.all(20),
//   decoration: BoxDecoration(
//     border: Border.all(
//       color: Colors.black,
//       width: 2,
//     ),
//     borderRadius: BorderRadius.circular(20),
//   ),
//   child: Column(children: [
//     ListTile(
//       title: const Text('Position 1'),
//       leading: Radio<Locations>(
//         value: Locations.goal1,
//         groupValue: _character,
//         onChanged: (Locations? value) {
//           setState(() {
//             _character = value;
//           });
//         },
//       ),
//     ),
//     ListTile(
//       title: const Text('Position 2'),
//       leading: Radio<Locations>(
//         value: Locations.goal2,
//         groupValue: _character,
//         onChanged: (Locations? value) {
//           setState(() {
//             _character = value;
//           });
//         },
//       ),
//     ),
//     ListTile(
//       title: const Text('Position 3'),
//       leading: Radio<Locations>(
//         value: Locations.goal3,
//         groupValue: _character,
//         onChanged: (Locations? value) {
//           setState(() {
//             _character = value;
//           });
//         },
//       ),
//     ),
//     ListTile(
//       title: const Text('Position 4'),
//       leading: Radio<Locations>(
//         value: Locations.goal4,
//         groupValue: _character,
//         onChanged: (Locations? value) {
//           setState(() {
//             _character = value;
//           });
//         },
//       ),
//     ),
//     ListTile(
//       title: const Text('Position 5'),
//       leading: Radio<Locations>(
//         value: Locations.goal5,
//         groupValue: _character,
//         onChanged: (Locations? value) {
//           setState(() {
//             _character = value;
//           });
//         },
//       ),
//     ),
//   ],),
// ),