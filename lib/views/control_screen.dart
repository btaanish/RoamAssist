import 'package:group_button/group_button.dart';
import 'package:roam_assist/constants.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:roam_assist/views/main_screen.dart';
import 'package:roam_assist/views/sound_screen.dart';
import 'package:speech_to_text/speech_to_text.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:assets_audio_player/assets_audio_player.dart';
import '../conn/client.dart';
import 'coordinates_screen.dart';
import 'package:string_validator/string_validator.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:audioplayers/audioplayers.dart';
import 'maps_list.dart';

class ControlScreen extends StatefulWidget {
  final List<String> maps;
  final List<String> locations1;
  final List<String> locations2;
  final String selectMap;
  final String selectedStart;
  final String selectedEnd;
  const ControlScreen({
    Key? key,
    required this.maps,
    required this.selectMap,
    required this.locations1,
    required this.locations2,
    required this.selectedStart,
    required this.selectedEnd,
  }) : super(key: key);

  @override
  State<ControlScreen> createState() => _ControlScreenState();
}

enum Locations { goal1, goal2, goal3, goal4, goal5 }

class _ControlScreenState extends State<ControlScreen> {
  bool _isListening = false;
  bool _isOnline = true;
  bool _isRunning = true;
  String currentStatus = "Idle";
  SpeechToText _speech = SpeechToText();
  final player = AudioPlayer();

  bool mapFlag = false;
  bool isStanding = true;

  List<String> speeds = ["Speeds"];
  String? selectedSpeed = "Speeds";
  String text = "";
  bool _firstOp = true;
  String convertDigitsToWords(String input) {
    Map<String, String> digitWords = {
      '0': 'zero',
      '1': 'one',
      '2': 'two',
      '3': 'three',
      '4': 'four',
      '5': 'five',
      '6': 'six',
      '7': 'seven',
      '8': 'eight',
      '9': 'nine'
    };

    String result = "";
    for (int i = 0; i < input.length; i++) {
      String currentChar = input[i];
      if (RegExp(r'[0-9]').hasMatch(currentChar)) {
        result += digitWords[currentChar].toString();
      } else {
        result += currentChar;
      }
    }
    return result;
  }

  String replaceSpecialCharacters(String input) {
    final regex = RegExp('[^a-zA-Z0-9 ]');
    print("////////////////" + input.replaceAll(regex, ''));
    return input.replaceAll(regex, ' ');
  }

  String insertSpaceBetweenTextAndDigit(String input) {
    final regex = RegExp(r'([a-zA-Z])(\d)');
    String s = input.replaceAllMapped(regex, (match) => '${match.group(1)} ${match.group(2)}');
    String s1 = "";
    for(int i = 0; i < s.length - 1; i++) {
      if(isNumeric(s[i]) && isAlpha(s[i + 1])) {
        s1 += "${s[i]} ";
      } else {
        s1 += s[i];
      }
    }
    return convertDigitsToWords(s1);
  }

  bool compareStrings(String str1, String str2) {
    final modifiedStr1 = insertSpaceBetweenTextAndDigit(replaceSpecialCharacters(str1));
    final modifiedStr2 = insertSpaceBetweenTextAndDigit(replaceSpecialCharacters(str2));

    return modifiedStr1 == modifiedStr2;
  }
  Set<String> extractWordsAtEndOfPhrase(String phrase, String searchString) {
    final words = phrase.split(' ');
    final index = words.lastIndexOf(searchString);

    if (index == -1) {
      return Set<String>(); // Empty set if the search string is not found
    }

    final endWords = words.sublist(index + 1);
    return Set<String>.from(endWords);
  }
  String eotHelper(String wrd, String s2) {
    final endWords = extractWordsAtEndOfPhrase(wrd, s2);
    String s1 = endWords.join(' ');
    return s1;
  }
  // void main() {
  //   final string1 = "Hello#123World!";
  //   final string2 = "Hello123 World?";
  //
  //   final result = compareStrings(string1, string2);
  //   print(result); // Output: true
  // }

  Future<String> textFunc(String s) async {
    // await player.setAsset("assets/sounds/go.wav");
    if(_firstOp) {
      await player.play(AssetSource("sounds/go.wav"));
      _firstOp = false;
      return "";
    }

        if (mapFlag) {
          await player.play(AssetSource("sounds/go.wav"));
          mapFlag = false;
        }
              return s;

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
    return FutureBuilder(
        future: textFunc(text),
        builder: (BuildContext context, AsyncSnapshot<String> txt) {
          return Scaffold(
              backgroundColor: kPrimaryColor,
              appBar: AppBar(
                backgroundColor: Colors.white,
                leading: BackButton(
                  onPressed: () => {Navigator.pop(context)},
                  color: Colors.black,
                ),
                title: const Text(
                  'Movement Control',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600),
                ),
                elevation: 2,
              ),
              body: Column (
                children: [
                  // Container(
                  //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                  //   child: const Row(
                  //     children: [
                  //       Icon(Icons.account_circle_outlined, size: 40, color: Colors.black),
                  //       SizedBox(width: 10),
                  //       Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text("Welcome!", style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: Colors.black)),
                  //           Text("User", style: TextStyle(fontFamily: 'Poppins', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                  //         ],
                  //       ),
                  //       Spacer(
                  //       ),
                  //       Icon(Icons.menu_outlined, size: 30, color: Colors.black)
                  //     ],
                  //   ),
                  // ),
                  //
                  const SizedBox(height: 90,),
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
                  //
                  // Container(
                  //   width: double.infinity,
                  //   padding: const EdgeInsets.symmetric(vertical: 0),
                  //   child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  //     Container(
                  //       margin: const EdgeInsets.all(30),
                  //       width: MediaQuery.of(context).size.width * 0.3,
                  //       height: MediaQuery.of(context).size.height * 0.05,
                  //       decoration: const BoxDecoration(
                  //         borderRadius: BorderRadius.all(
                  //           Radius.circular(10),
                  //         ),
                  //         color: kTextColor,
                  //       ),
                  //       child: Center(
                  //         child: TextButton(
                  //           onPressed: () async {
                  //             sendCommand("stand");
                  //           },
                  //           child: const Text(
                  //             'Stand',
                  //             style: TextStyle(
                  //               color: kPrimaryColor,
                  //               fontSize: 20,
                  //               fontFamily: 'Poppins',
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //     Container(
                  //       margin: const EdgeInsets.all(30),
                  //       width: MediaQuery.of(context).size.width * 0.3,
                  //       height: MediaQuery.of(context).size.height * 0.05,
                  //       decoration: const BoxDecoration(
                  //         borderRadius: BorderRadius.all(
                  //           Radius.circular(10),
                  //         ),
                  //         color: kTextColor,
                  //       ),
                  //       child: Center(
                  //         child: TextButton(
                  //           onPressed: () async {
                  //             sendCommand("sit");
                  //           },
                  //           child: const Text(
                  //             'Sit',
                  //             style: TextStyle(
                  //               color: kPrimaryColor,
                  //               fontSize: 20,
                  //               fontFamily: 'Poppins',
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ]),
                  // ),
                  Container(
                    child: Text(
                      txt.data.toString(),
                    ),
                  ),


                  // SizedBox(
                  //     width: 300,
                  //     child: DropdownButtonFormField<String>(
                  //         decoration: InputDecoration(
                  //             enabledBorder: OutlineInputBorder(
                  //                 borderRadius: BorderRadius.circular(12),
                  //                 borderSide: BorderSide(width: 3, color: Colors.black)
                  //             )
                  //         ),
                  //         items: maps
                  //             .map((map) => DropdownMenuItem<String>(
                  //             value: map,
                  //             child: Text(
                  //                 map,
                  //                 style: TextStyle(
                  //                   color: Colors.black,
                  //                   fontSize: 20,
                  //                   fontFamily: 'Poppins',
                  //                 )
                  //             ))).toList(),
                  //         value: selectedMap,
                  //         onChanged: (map) async {
                  //           // print("/////////////////////////////////////////");
                  //           // print(map.toString());
                  //           // print("???????????????????????????????????????????");
                  //           String s4 = await sendCommand("get_start_and_goal:" + map.toString());
                  //           // String s4 = "";
                  //           // if(maps.toString() == "maps") {
                  //           //   s4 = "rooms:stairs";
                  //           // } else {
                  //           //   s4 = "chairs:tables";
                  //           // }
                  //           // print(s4);
                  //           setState(()  {
                  //             selectedMap = map;
                  //             List<String> locs = textBefColon(s4);
                  //             print(locs);
                  //             locations1 = textToList(locs[0]);
                  //             selectedStart = locations1[0];
                  //             locations2 = textToList(locs[1]);
                  //             selectedEnd = locations2[0];
                  //           });
                  //         })
                  // ),
                  // const SizedBox(height: 20,),
                  // SizedBox(
                  //   width: 300,
                  //   child: DropdownButtonFormField<String>(
                  //       decoration: InputDecoration(
                  //           enabledBorder: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(12),
                  //               borderSide: BorderSide(width: 3, color: Colors.black)
                  //           )
                  //       ),
                  //       items: locations1
                  //           .map((location) => DropdownMenuItem<String>(
                  //           value: location,
                  //           child: Text(
                  //               location,
                  //               style: TextStyle(
                  //                 color: Colors.black,
                  //                 fontSize: 20,
                  //                 fontFamily: 'Poppins',
                  //               )
                  //           ))).toList(),
                  //       value: selectedStart,
                  //       onChanged: (start) => setState(() {
                  //         selectedStart = start;
                  //         print("set_initial_pose:" + selectedStart.toString());
                  //         sendCommand("set_initial_pose:" + selectedStart.toString());
                  //       })),
                  // ),
                  // const SizedBox(height: 20,),
                  // SizedBox(
                  //   width: 300,
                  //   child: DropdownButtonFormField<String>(
                  //       decoration: InputDecoration(
                  //           enabledBorder: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(12),
                  //               borderSide: BorderSide(width: 3, color: Colors.black)
                  //           )
                  //       ),
                  //       items: locations2
                  //           .map((location) => DropdownMenuItem<String>(
                  //           value: location,
                  //           child: Text(
                  //               location,
                  //               style: TextStyle(
                  //                 color: Colors.black,
                  //                 fontSize: 20,
                  //                 fontFamily: 'Poppins',
                  //               )
                  //           ))).toList(),
                  //       value: selectedEnd,
                  //       onChanged: (end) => setState(() {
                  //         selectedEnd = end;
                  //         print("set_goal:" + selectedEnd.toString());
                  //         sendCommand("set_goal:" + selectedEnd.toString());
                  //       })),
                  // ),
                  const SizedBox(height: 90,),
                  SizedBox(
                    width: 300,
                    child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(width: 3, color: Colors.black)
                            )
                        ),
                        items: speeds
                            .map((speed) => DropdownMenuItem<String>(
                            value: speed,
                            child: Text(
                                speed,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                )
                            ))).toList(),
                        value: selectedSpeed,
                        onChanged: (speed) => setState(() {
                          selectedSpeed = speed;
                          print("Selected speed is: $selectedSpeed");
                          sendCommand("set_goal:${widget.selectedEnd}");
                        })),
                  ),
                  const SizedBox(height: 100,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 150,

                        child: TextButton(

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
                            // currentStatus = "Walking";
                            // sendCommand("start_move");
                            Navigator.push(context, MaterialPageRoute(builder: (context) => MainScreen()));
                            setState(() {
                              _isRunning = true;
                            });

                          },
                          child: const Text(
                            'Reset',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),

                      // TextButton(
                      //   style: ButtonStyle(
                      //       backgroundColor: const MaterialStatePropertyAll(Colors.black),
                      //       alignment: Alignment.center,
                      //       shape: MaterialStateProperty.all(
                      //           RoundedRectangleBorder(
                      //             borderRadius: BorderRadius.circular(12.0),
                      //           )
                      //       )
                      //   ),
                      //   onPressed: () {
                      //     Navigator.pushNamed(context, 'coordinates_screen');
                      //   },
                      //   child: Text(
                      //     'Add Coordinates',
                      //     style: TextStyle(
                      //       color: Colors.white,
                      //       fontSize: 20,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                  // SizedBox(height: 20,),

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
                    // await player.setSource(AssetSource('assets/sounds/siri-high.mp3'));
                    // await player.resume();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SoundScreen(locations1: widget.locations1,
                      locations2: widget.locations2,
                      maps: widget.maps,
                      selectMap: widget.selectMap,
                      start: widget.selectedStart,
                      end: widget.selectedEnd,)));
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

                    // await player.play(AssetSource("sounds/go.wav"));
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
                        //  Navigator.push(context, MaterialPageRoute(builder: (context) => MapChoiceScreen()));
                          // if (_isOnline) {
                          //   sendCommand("stop_nav");
                          //   setState(() {
                          //     Navigator.pushNamed(context, 'maps_list');
                          //     _isOnline = !_isOnline;
                          //   });
                          // } else {
                          //   String s3 = await sendCommand("start");
                          //   setState(() {
                          //     Navigator.pushNamed(context, 'maps_list');
                          //     maps = textToList(s3);
                          //     selectedMap = maps[0];
                          //     _isOnline = !_isOnline;
                          //     speeds = ["slow", "med", "fast"];
                          //     selectedSpeed = "slow";
                          //   });
                          // }
                        },
                        icon: const Icon(Icons.power_settings_new, color: Colors.white,),
                      ),
                    ],
                  ),
                ),
              )
          );
        }
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

