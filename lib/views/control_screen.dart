import 'package:group_button/group_button.dart';
import 'package:roam_assist/constants.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:roam_assist/views/main_screen.dart';
import 'package:roam_assist/views/sound_screen.dart';
import '../conn/client.dart';
import 'coordinates_screen.dart';
import 'package:string_validator/string_validator.dart';
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
  String currentStatus = "Walking";
  final player = AudioPlayer();

  bool mapFlag = false;
  bool isStanding = true;
  List<String> speeds = ["Speeds"];
  String? selectedSpeed = "Speeds";
  String text = "";
  bool _firstOp = true;

  Future<String> textFunc(String s) async {
    // await player.setAsset("assets/sounds/go.wav");
    if(_firstOp) {
      Future.delayed(const Duration(milliseconds: 1000), () async {
        await player.play(AssetSource("sounds/go.wav"));
      });
      _firstOp = false;
      return "";
    }
    if (mapFlag) {
      await player.play(AssetSource("sounds/go.wav"));
      mapFlag = false;
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

                  Container(
                    child: Text(
                      txt.data.toString(),
                    ),
                  ),

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
                            Navigator.popUntil(context, (route) => route.isFirst);
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SoundScreen(locations1: widget.locations1,
                      locations2: widget.locations2,
                      maps: widget.maps,
                      selectMap: widget.selectMap,
                      start: widget.selectedStart,
                      end: widget.selectedEnd,)));
                  },
                  onTapUp: (details) async {
                    setState(() async {
                      _isListening = false;
                    });
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
                        tooltip: "Press to pause or unpause the dog",
                      ),

                      SizedBox(width: 50,),

                      IconButton(
                        onPressed: () async {
                          setState(() {
                            if(isStanding) {
                              sendCommand("sit");
                            } else {
                              sendCommand("stand");
                            }
                            isStanding = !isStanding;
                          });
                        },
                        icon: Icon(isStanding ? Icons.man : Icons.accessibility_rounded, color: Colors.white,),
                        tooltip: "Press to either let the robot stand or sit",
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