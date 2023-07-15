import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/coordinates.dart';
import 'package:latlong2/latlong.dart';
import 'package:tuple/tuple.dart';
import 'package:geolocator/geolocator.dart';

class Navigation {

  List<Coordinates> decodeEncodedPolyline(String encoded) {
    List<Coordinates> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;
      Coordinates p = Coordinates(latitude: (lat / 1E5).toDouble(), longitude: (lng / 1E5).toDouble());
      poly.add(p);
    }
    return poly;
  }

  Tuple2<double,double> findNearest(List<Coordinates> coordinates, Coordinates currentCoordinate) {
    double nearestDistance = double.infinity;
    Coordinates nearestCoordinate = currentCoordinate;
    const Distance distance = Distance();
    double currentLat = currentCoordinate.latitude;
    double currentLon = currentCoordinate.longitude;
    for (final coordinate in coordinates) {
      double lat = coordinate.latitude;
      double lon = coordinate.longitude;
      final double currentDistance = distance(
          LatLng(lat,lon),
          LatLng(currentLat,currentLon)
      );

      if (currentDistance < nearestDistance) {
        nearestDistance = currentDistance;
        nearestCoordinate = coordinate;
      }
    }
    double bearing = Geolocator.bearingBetween(currentLat, currentLon, nearestCoordinate.latitude, nearestCoordinate.longitude);
    return Tuple2<double,double>(nearestDistance,bearing);
  }


  // give a list of waypoints between start and end
  void getRoute(Coordinates start, Coordinates end) async {
    const APIKEY = "AIzaSyBgTZioZoYsFeE33WHy_biJDXKEKgABTeg";
    String origin = "${start.latitude},${start.longitude}";
    String destination = "${end.latitude},${end.longitude}";
    const mode = "walking";
    String url = "https://maps.googleapis.com/maps/api/directions/json?destination=$destination&mode=$mode&origin=$origin&key=$APIKEY";
    try {
      http.Response response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body);
      var encoded_polyline = data["routes"][0]["overview_polyline"]["points"];
      List<Coordinates> waypoints = decodeEncodedPolyline(encoded_polyline);
      var tuple = findNearest(waypoints, Coordinates(latitude: 1.2946900584496173, longitude: 103.77341260752276));
      final double nearestDistance = tuple.item1;
      final double bearing = tuple.item2;
      print(nearestDistance);
      print(bearing);

      // var steps = data["routes"][0]["legs"][0]["steps"];
      // List<Waypoint> waypointList = [];
      // for (final step in steps) {
      //   double distance = step["distance"]["value"].toDouble();
      //   double lat = step["end_location"]["lat"].toDouble();
      //   double lng = step["end_location"]["lng"].toDouble();
      //   Coordinates coordinates = Coordinates(latitude: lat , longitude: lng);
      //   final htmlDirections = parse(step["html_instructions"]);
      //   final String? parsedString = parse(htmlDirections.body?.text).documentElement?.text;
      //   String orientation = step["maneuver"] ??= parsedString?.split(" ")[1];
      //   Waypoint waypoint = Waypoint(distance: distance, end: coordinates, orientation: orientation);
      //   waypointList.add(waypoint);
      //
      // }


    } catch (e) {
      print(e.toString());
    }
  }




}