// @dart=3.0.5
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roam_assist/widgets/coordinate_input.dart';
import 'package:roam_assist/models/coordinates.dart';
import 'package:roam_assist/widgets/coordinates_list.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:roam_assist/models/tts.dart';
import 'package:roam_assist/navigation.dart';
import 'package:tuple/tuple.dart';

class CoordinatesScreen extends StatefulWidget {
  const CoordinatesScreen({super.key});

  @override
  State<CoordinatesScreen> createState() => _CoordinatesScreenState();
}

class _CoordinatesScreenState extends State<CoordinatesScreen> {
  List<Coordinates> coordinates_list = [];

  void addCoordinates(Coordinates c) {
    coordinates_list.add(c);
  }

  // String selectedValue = "Select your map";

  Widget buildBottomSheet(BuildContext context) {
    return CoordinateInputScreen(addCoordinates: addCoordinates);
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          child: Text("Select your map"), value: "Select your map"),
      DropdownMenuItem(child: Text("SOC Com 3"), value: "SOC Com 3"),
    ];
    return menuItems;
  }

  // For Live Location!
  double long = 0.00; //user's current location
  double lat = 0.00;  //users current location
  double bearing = 0.00; // from user to target
  double compass = 0.00;  // where the user is facing now
  bool _hasPermissions = false;

  @override
  void initState() {
    super.initState();
    _initSpeechTimer();
    _fetchPermissionStatus();
  }

  StreamSubscription<Position>? positionStream;
  bool stream_status = false;

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) => {
          if (mounted)
            {
              setState(() {
                _hasPermissions = (status == PermissionStatus.granted);
              })
            }
        });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.

    stream_status = true;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Checks and request for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    final LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 0, // distance moved before next location ping
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) async {
      final CompassEvent tmp = await FlutterCompass.events!.first;
      Navigation navigate = Navigation();
      Tuple2<double,double> res = await navigate.getRoute(Coordinates(latitude: lat , longitude: long ), coordinates_list[0]);
      setState(() {
        position == null
            ? 'Unknown'
            : {
                lat = position.latitude,
                long = position.longitude,
                bearing = res.item2,
                compass = tmp.heading!
              };
      });
    });

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  final Speech tts = Speech();
  late Timer _speechTimer;
  bool _isSpeaking = false;

  void _initSpeechTimer() {
    _speechTimer = Timer.periodic(Duration(seconds: 2), (timer) {
      if (!_isSpeaking) {
        _speakCommands();
      }
    });
  }

  void _speakCommands() async {
    if (coordinates_list.isNotEmpty) {
      double bearingDiff = compass - bearing;

      if (bearingDiff > 10) {
        await tts.speak_turn_left();
      } else if (bearingDiff < -10) {
        await tts.speak_turn_right();
      } else {
        await tts.speak_walk_straight();
      }
    }
  }

  @override
  void dispose() {
    _speechTimer.cancel();
    super.dispose();
  }

  void _stopSpeech() {
    tts.stop(); // Stop the speech
    _speechTimer.cancel(); // Cancel the speech timer
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => {Navigator.pop(context)}),
          title: const Text(
            'Map',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 2,
        ),
        body: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        _determinePosition();
                        Permission.locationWhenInUse.request().then((ignored) {
                          _fetchPermissionStatus();
                        });
                        // _buildCompass();
                      },
                      child: Text('start tracking'),
                    ),
                    TextButton(
                      onPressed: () {
                        positionStream?.cancel();
                        setState(() {
                          lat = 0.00;
                          long = 0.00;
                          bearing = 0.00;
                        });
                      },
                      child: Text('stop tracking'),
                    ),
                  ],
                ),
                Center(
                  child: Column(
                    children: [
                      Text(long.toString()),
                      Text(lat.toString()),
                      Text(bearing.toString()),
                      Text(compass.toString())
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 100,
            ),
            const Padding(
              padding: EdgeInsets.only(left: 52, right: 59),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Longitude',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    'Latitude',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: CoordinatesList(
                  coord_list: coordinates_list,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      tts.speak_start(); // Start the journey and activate speech
                      _initSpeechTimer(); // Start the speech timer
                      _speakCommands(); // Determine and speak turn commands
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 212, 211, 211),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Take me there",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_circle_right, color: Colors.black),

                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _stopSpeech(); // Stop the speech and timer
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.red, // Use a different color for the terminate button
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Terminate",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.close, color: Colors.white),
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      // Navigation navigate = Navigation();
                      // navigate.getRoute(Coordinates(latitude: 1.2946900584496173, longitude: 103.77341260752276), Coordinates(latitude: 1.2948466915714363, longitude: 103.77367303592946));
                      showModalBottomSheet(
                          context: context, builder: buildBottomSheet);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 212, 211, 211),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Add Position",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 20,
                                  color: Colors.black)),
                          Spacer(),
                          Icon(Icons.arrow_circle_right, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
