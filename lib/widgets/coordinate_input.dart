import 'package:flutter/material.dart';
import 'package:roam_assist/models/coordinates.dart';


class CoordinateInputScreen extends StatefulWidget {

  Function addCoordinates;

  CoordinateInputScreen({required this.addCoordinates});

  @override
  State<CoordinateInputScreen> createState() => _CoordinateInputScreenState();
}

class _CoordinateInputScreenState extends State<CoordinateInputScreen> {

  double longitude = 0;
  double latitude = 0;

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
                  Text(
                    'Coordinates',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  TextField(
                    autofocus: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintText: 'Longitude',
                    ),
                    onChanged: (text) {
                      longitude = double.parse(text);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    autofocus: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      hintText: 'Latitude',
                    ),
                    onChanged: (text) {
                      latitude = double.parse(text);
                    },
                  ),
                  SizedBox(height: 50.0,),
                  TextButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.black),
                        alignment: Alignment.center),
                    onPressed: () {
                      Coordinates c = Coordinates(latitude: latitude, longitude: longitude);
                      setState(() {
                        widget.addCoordinates(c);
                      });
                      //to remove bottom sheet once added task
                      Navigator.pop(context);
                    },

                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(height: 300.0,),
                ],
              ),
            ),
        ),

      ],
    );
  }
}
