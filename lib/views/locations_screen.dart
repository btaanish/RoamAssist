import 'package:group_button/group_button.dart';
import 'package:roam_assist/constants.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:roam_assist/views/control_screen.dart';
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

class LocationScreen extends StatefulWidget {
  final List<String> locations1;
  final List<String> locations2;
  final List<String> maps;
  final String selectMap;
  const LocationScreen({
    Key? key,
  required this.locations1,
  required this.locations2,
    required this.maps,
    required this.selectMap,
  }) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

enum Locations { goal1, goal2, goal3, goal4, goal5 }

class _LocationScreenState extends State<LocationScreen> {
  bool _isListening = false;
  bool _isOnline = false;
  bool _isRunning = false;
  String currentStatus = "Idle";
  SpeechToText _speech = SpeechToText();
  final player = AudioPlayer();

  bool mapFlag = false;

  String? selectedStart = "Locations";
  String? selectedEnd = "Locations";
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
      selectedStart = widget.locations1[0];
      selectedEnd = widget.locations2[0];
      await player.play(AssetSource("sounds/LocationScreen.wav"));
      _firstOp = false;
      return "";
    } else {
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
        // AssetsAudioPlayer.newPlayer().open(
        //   Audio("assets/sounds/go.wav"),
        //   showNotification: true,
        // );
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
        // AssetsAudioPlayer.newPlayer().open(
        //   Audio("assets/sounds/go.wav"),
        //   showNotification: true,
        // );
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
      } else if (s == "go to position 3" ||
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
        // player.play(AssetSource('sounds/go.wav'));
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
      } else if (s == "I would like to use com 3 stairs") {
        List<String> locs = textBefColon(
            await sendCommand("get_start_and_goal:com3_stairs")
        );
        // print(locs);
        // print("lol");
        // widget.locations1 = textToList(locs[0]);
        // selectedStart = widget.locations1[0];
        // locations2 = textToList(locs[1]);
        // selectedEnd = locations2[0];
      } else if (s == "I would like to use com 3") {
        List<String> locs = textBefColon(
            await sendCommand("get_start_and_goal:com3")
        );
        // print(locs);
        // print("lol");
        // locations1 = textToList(locs[0]);
        // selectedStart = locations1[0];
        // locations2 = textToList(locs[1]);
        // selectedEnd = locations2[0];
      } else {
        if (s.contains("use") ||
            s.contains("please use ") ||
            s.contains("could you use ") ||
            s.contains("I would like to use ") ||
            s.contains("Use ") ||
            s.contains("Please use ") ||
            s.contains("Could you use ")) {
          print("In maps selection now");
          for (int j = 0; j < widget.maps.length; j++) {
            if (compareStrings(
                eotHelper(s, "use").toLowerCase(), widget.maps[j].toLowerCase()) ||
                compareStrings(
                    eotHelper(s, "Use").toLowerCase(), widget.maps[j].toLowerCase())) {
              print("${widget.maps[j]} is selected");
              mapFlag = true;
              // List<String> locs = textBefColon(
              //     await sendCommand("get_start_and_goal:${maps[j]}")
              // );
              // // print(locs);
              // // print("lol");
              // locations1 = textToList(locs[0]);
              // selectedStart = locations1[0];
              // locations2 = textToList(locs[1]);
              // selectedEnd = locations2[0];
              // print(locations1);
              // print(locations2);
            }
          }
        }
        if (mapFlag) {
          await player.play(AssetSource("sounds/go.wav"));
          mapFlag = false;
        }
        //   for (int i = 0; i < maps.length; i++) {
        //   String str = maps.elementAt(i);
        //   if (s == "use $str" ||
        //       s == "please use $str" ||
        //       s == "could you use $str" ||
        //       s == "I would like to use $str" ||
        //       s == "Use $str" ||
        //       s == "Please use $str" ||
        //       s == "Could you use $str" ) {
        //     print("$str successfully selected");
        //     // String s4 = "";
        //     // if(maps.toString() == "maps") {
        //     //   s4 = "rooms:stairs";
        //     // } else {
        //     //   s4 = "chairs,beds:tables, sofas";
        //     // }
        //     List<String> locs = textBefColon(
        //         await sendCommand("get_start_and_goal:" + str)
        //     );
        //     // print(locs);
        //     // print("lol");
        //     locations1 = textToList(locs[0]);
        //     selectedStart = locations1[0];
        //     locations2 = textToList(locs[1]);
        //     selectedEnd = locations2[0];
        //     // print(locations1);
        //     // print(locations2);
        //   }
        // }
        if (s.contains("take me from") ||
            s.contains("please take me from") ||
            s.contains("could you take me from") ||
            s.contains("I would like to go from") ||
            s.contains("Take me from") ||
            s.contains("Please take me from") ||
            s.contains("Could you take me from")) {
          print("in start loc selection");
          for (int i = 0; i < widget.locations1.length; i++) {
            String str = widget.locations1.elementAt(i);
            print(str);
            print(eotHelper(s, "from").toLowerCase());
            if (compareStrings(
                eotHelper(s, "from").toLowerCase(), str.toLowerCase()) ||
                compareStrings(
                    eotHelper(s, "From").toLowerCase(), str.toLowerCase())) {
              print("going from $str");
              sendCommand("set_initial_pose:" + str);
            }
          }
        }
        if (s.contains("take me to") ||
            s.contains("please take me to") ||
            s.contains("could you take me to") ||
            s.contains("I would like to go to") ||
            s.contains("Take me to") ||
            s.contains("Please take me to") ||
            s.contains("Could you take me to")) {
          for (int i = 0; i < widget.locations2.length; i++) {
            String str = widget.locations2.elementAt(i);
            if (compareStrings(
                eotHelper(s, "to").toLowerCase(), str.toLowerCase()) ||
                compareStrings(
                    eotHelper(s, "to").toLowerCase(), str.toLowerCase())) {
              print("going to $str");
              sendCommand("set_goal:" + str);
              sendCommand("start_nav");
            }
          }
        }
      }
      return s;
    }
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
                  'Start and End Locations',
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
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  //   margin: const EdgeInsets.symmetric(horizontal: 20),
                  //   decoration: BoxDecoration(
                  //     color: const Color.fromARGB(255, 212, 211, 211),
                  //     borderRadius: BorderRadius.circular(20),
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       const Text("Unitree Go 1", style: TextStyle(fontFamily: 'Poppins', fontSize: 20, color: Colors.black)),
                  //       const Spacer(),
                  //
                  //       _isOnline ? const Text("Online", style: TextStyle(fontFamily: 'Poppins',
                  //           fontSize: 15,
                  //           color: Colors.black))
                  //           : const Text("Offline", style: TextStyle(fontFamily: 'Poppins',
                  //           fontSize: 15,
                  //           color: Colors.black)),
                  //       // draw a circle here
                  //       _isOnline ? Container(
                  //         margin: const EdgeInsets.only(left: 5),
                  //         width: 10,
                  //         height: 10,
                  //         decoration: const BoxDecoration(
                  //           color: Colors.green,
                  //           shape: BoxShape.circle,
                  //         ),
                  //       )
                  //           : Container(
                  //         margin: const EdgeInsets.only(left: 5),
                  //         width: 10,
                  //         height: 10,
                  //         decoration: const BoxDecoration(
                  //           color: Colors.red,
                  //           shape: BoxShape.circle,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  //
                  // Container(
                  //   margin: const EdgeInsets.only(right: 20, top:20),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children:  [
                  //       Icon(Icons.pets_outlined, size: 15, color: Colors.black),
                  //       Text(" $currentStatus", style: TextStyle(fontFamily: 'Poppins', fontSize: 15, color: Colors.black)),
                  //     ],
                  //   ),
                  // ),
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
                  const SizedBox(height: 150,),
                  SizedBox(
                    width: 300,
                    child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(width: 3, color: Colors.black)
                            )
                        ),
                        items: widget.locations1
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
                          print("set_initial_pose:" + selectedStart.toString());
                          // sendCommand("set_initial_pose:" + selectedStart.toString());
                        })),
                  ),
                  const SizedBox(height: 50,),
                  SizedBox(
                    width: 300,
                    child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(width: 3, color: Colors.black)
                            )
                        ),
                        items: widget.locations2
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
                          print("set_goal:" + selectedEnd.toString());
                          // sendCommand("set_goal:" + selectedEnd.toString());
                        })),
                  ),
                  const SizedBox(height: 70,),
                  // SizedBox(
                  //   width: 300,
                  //   child: DropdownButtonFormField<String>(
                  //       decoration: InputDecoration(
                  //           enabledBorder: OutlineInputBorder(
                  //               borderRadius: BorderRadius.circular(12),
                  //               borderSide: BorderSide(width: 3, color: Colors.black)
                  //           )
                  //       ),
                  //       items: speeds
                  //           .map((speed) => DropdownMenuItem<String>(
                  //           value: speed,
                  //           child: Text(
                  //               speed,
                  //               style: TextStyle(
                  //                 color: Colors.black,
                  //                 fontSize: 20,
                  //                 fontFamily: 'Poppins',
                  //               )
                  //           ))).toList(),
                  //       value: selectedSpeed,
                  //       onChanged: (speed) => setState(() {
                  //         selectedSpeed = speed;
                  //         print("Selected speed is: $selectedSpeed");
                  //         sendCommand("set_goal:$selectedEnd");
                  //       })),
                  // ),
                  // const SizedBox(height: 20,),
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
                          // sendCommand("start_move");
                          setState(() {
                            _isRunning = true;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => ControlScreen(
                              maps: widget.maps,
                              selectMap: widget.selectMap,
                              locations1: widget.locations1,
                              locations2: widget.locations2,
                              selectedStart: selectedStart.toString(),
                              selectedEnd: selectedEnd.toString(),
                            )));
                          });
                          // String goal_id = _character.toString().split('.').last;
                          // print("Goal ID: $goal_id");
                          // sendCommand(goal_id);
                        },
                        child: const Text(
                          'Start Navigation',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      // const SizedBox(width: 30,),
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SoundScreen(
                      locations1: widget.locations1,
                      locations2: widget.locations2,
                      maps: widget.maps,
                      selectMap: widget.selectMap,
                      start: selectedStart.toString(),
                      end: selectedEnd.toString(),
                    )));
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
                      // IconButton(
                      //   onPressed: () {
                      //     if (_isRunning) {
                      //       sendCommand("pause_move");
                      //       currentStatus = "Standing Idle";
                      //     } else {
                      //       sendCommand("start_move");
                      //       currentStatus = "Walking";
                      //     }
                      //     setState(() {
                      //       _isRunning = !_isRunning;
                      //     });
                      //   },
                      //   icon: Icon(
                      //     _isRunning ? Icons.pause : Icons.play_arrow_rounded,
                      //     color: Colors.white,),
                      // ),
                      // SizedBox(width: 50,),
                      //
                      // IconButton(
                      //   onPressed: () async {
                      //     Navigator.push(context, MaterialPageRoute(builder: (context) => MapChoiceScreen()));
                      //     // if (_isOnline) {
                      //     //   sendCommand("stop_nav");
                      //     //   setState(() {
                      //     //     Navigator.pushNamed(context, 'maps_list');
                      //     //     _isOnline = !_isOnline;
                      //     //   });
                      //     // } else {
                      //     //   String s3 = await sendCommand("start");
                      //     //   setState(() {
                      //     //     Navigator.pushNamed(context, 'maps_list');
                      //     //     maps = textToList(s3);
                      //     //     selectedMap = maps[0];
                      //     //     _isOnline = !_isOnline;
                      //     //     speeds = ["slow", "med", "fast"];
                      //     //     selectedSpeed = "slow";
                      //     //   });
                      //     // }
                      //   },
                      //   icon: const Icon(Icons.power_settings_new, color: Colors.white,),
                      // ),
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

