import 'package:flutter/material.dart';
import 'package:roam_assist/models/coordinates.dart';
import 'package:roam_assist/views/map_screen.dart';


class CoordinateInputScreen extends StatefulWidget {

  Function addCoordinates;

  CoordinateInputScreen({required this.addCoordinates});


  @override
  State<CoordinateInputScreen> createState() => _CoordinateInputScreenState();
}

class _CoordinateInputScreenState extends State<CoordinateInputScreen> {

  final TextEditingController _controllerLong = TextEditingController();
  final TextEditingController _controllerLat = TextEditingController();

  double longitude = 0;
  double latitude = 0;

  double longMap = 0;
  double latMap = 0;

  void addCoordinateMap(double long, double lat) {
    setState(() {
      longMap = double.parse(long.toStringAsFixed(5));
      latMap = double.parse(lat.toStringAsFixed(5));
      print(latMap);
      print(longMap);
      final updatedLong = longMap.toString();
      _controllerLong.value = _controllerLong.value.copyWith(
        text: updatedLong,
        selection: TextSelection.collapsed(offset: updatedLong.length),
      );
      final updatedLat = latMap.toString();
      _controllerLat.value = _controllerLat.value.copyWith(
        text: updatedLat,
        selection: TextSelection.collapsed(offset: updatedLat.length),
      );
    });
  }

  Widget showMap(BuildContext context) {
    return MapScreen(addCoordinates: addCoordinateMap);
  }


  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
            color: Color(0xff757575),
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  const Text(
                    'Coordinates',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  TextField(
                    autofocus: true,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintText: 'Longitude',
                    ),
                    controller: _controllerLong,
                    onChanged: (text) {
                      longitude = double.parse(text);
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    autofocus: true,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintText: 'Latitude',
                    ),
                    controller: _controllerLat,
                    onChanged: (text) {
                      latitude = double.parse(text);
                    },
                  ),
                  const SizedBox(height: 50.0,),
                  TextButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.black),
                        alignment: Alignment.center),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => showMap(context)),
                      );
                    },
                    child: const Text(
                      'Select From Map',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  TextButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.black),
                        alignment: Alignment.center),
                    onPressed: () {
                      Coordinates c = Coordinates(latitude: latMap == 0 ? latitude : latMap, longitude: longMap == 0 ? longitude : longMap);
                      if (c.longitude != 0.0 && c.latitude != 0.0) {
                        widget.addCoordinates(c);
                      }
                      latMap = 0;
                      longMap = 0;
                      latitude = 0;
                      longitude = 0;
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 300.0,),
                ],
              ),
            ),
        ),

      ],
    );
  }
}
