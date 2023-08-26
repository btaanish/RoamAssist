import 'package:flutter/material.dart';

class LocationData extends ChangeNotifier {
  double? lat;
  double? long;
  double? bearing;
  double? compass;

  void updateLocation(double newLat, double newLong, double newBearing, double newCompass) {
    lat = newLat;
    long = newLong;
    bearing = newBearing;
    compass = newCompass;
    notifyListeners(); // Notify listeners that data has changed
  }
}
