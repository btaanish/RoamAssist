// @dart=3.0.5
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:roam_assist/widgets/coordinate_input.dart';
import 'package:roam_assist/models/coordinates.dart';
import 'package:roam_assist/widgets/coordinates_list.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:roam_assist/navigation.dart';


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
  double long = 0.00;
  double lat = 0.00;
  double bearing = 0.00;
  double compass = 0.00;
  bool _hasPermissions = false;

  @override
  void initState() {
    super.initState();
    _fetchPermissionStatus();
  }

  StreamSubscription<Position>? positionStream;
  bool stream_status = false;

  void _fetchPermissionStatus() {
    Permission.locationWhenInUse.status.then((status) => {
      if (mounted) {
        setState(() {
          _hasPermissions = (status == PermissionStatus.granted);
        })
      }
    });
  }

  // Widget _buildCompass() {
  //   return StreamBuilder<CompassEvent>(
  //     stream: FlutterCompass.events,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasError) {
  //           return Text('Error reading heading: ${snapshot.error}' );
  //         }
  //
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return const Center(
  //             child: CircularProgressIndicator(),
  //           );
  //         }
  //
  //         double? direction = snapshot.data!.heading;
  //
  //         if (direction == null) {
  //           return const Center(
  //             child:  Text('Device does not have sensors'),
  //           );
  //         }
  //
  //         compass = direction;
  //         return Text(direction.toString());
  //       }
  //   );
  // }

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
      setState(() {
        position == null
            ? 'Unknown'
            : {
          lat = position.latitude,
          long = position.longitude,
          bearing = Geolocator.bearingBetween(lat, long, coordinates_list[0].latitude, coordinates_list[0].longitude),
          compass = tmp.heading!
        };

      });
    });

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
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

            // Container(
            //     margin: const EdgeInsets.symmetric(horizontal: 30),
            //     child: DropdownButton(
            //       value: selectedValue,
            //       borderRadius: BorderRadius.circular(20),
            //       style: const TextStyle(
            //           color: Colors.black, fontSize: 20, fontFamily: 'Poppins'),
            //       focusColor: const Color.fromARGB(255, 212, 211, 211),
            //       isExpanded: true,
            //       dropdownColor: const Color.fromARGB(255, 212, 211, 211),
            //       items: dropdownItems,
            //       onChanged: (value) {
            //         setState(() {
            //           selectedValue = value.toString();
            //         });
            //       },
            //     )),
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
                          Text("Take me there",
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
    ;
  }
}
