import 'coordinates.dart';

// Each waypoint is allocated distance in metres, endpoint and its orientation
class Waypoint {

  double distance;
  Coordinates end;
  String orientation;

  Waypoint({required this.distance, required this.end, required this.orientation});

  @override
  String toString() {
    // TODO: implement toString
    String endString = end.toString();
    return "Distance is $distance \n Coordinate is $endString \n orientation is $orientation";
  }

}