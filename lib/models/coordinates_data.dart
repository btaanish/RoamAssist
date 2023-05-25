import 'coordinates.dart';
import 'package:flutter/foundation.dart';

class CoordinatesData {
  List<Coordinates> coordinates_list = [

  ];

  void addCoordinates(Coordinates c) {
    coordinates_list.add(c);
  }
}