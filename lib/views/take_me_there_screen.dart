import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

import 'package:flutter/material.dart';

import '../models/location_data.dart';

class TakeMeThereScreen extends StatefulWidget {
  final double? lat;
  final double? long;
  final double? bearing;
  final double? compass;

  const TakeMeThereScreen({
    Key? key,
    this.lat,
    this.long,
    this.bearing,
    this.compass,
  }) : super(key: key);

  @override
  State<TakeMeThereScreen> createState() => _TakeMeThereScreenState();
}


class _TakeMeThereScreenState extends State<TakeMeThereScreen> {
  @override
  Widget build(BuildContext context) {
    var locationData = Provider.of<LocationData>(context);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => {Navigator.pop(context)}),
          title: const Text(
            'On the way!',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 2,
        ),
        backgroundColor: kPrimaryColor,
        body: Column(
          children: [
            Text(
              'Latitude: ${widget.lat}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Longitude: ${widget.long}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Bearing: ${widget.bearing}',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              'Compass: ${widget.compass}',
              style: TextStyle(fontSize: 18),
            ),
            // Other widgets can be added here
          ],
        ),
      ),
    );
  }
}

