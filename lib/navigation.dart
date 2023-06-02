import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/coordinates.dart';
import 'models/waypoint.dart';
import 'package:html/parser.dart';

class Navigation {

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
      var steps = data["routes"][0]["legs"][0]["steps"];
      List<Waypoint> waypointList = [];
      for (final step in steps) {
        double distance = step["distance"]["value"].toDouble();
        double lat = step["end_location"]["lat"].toDouble();
        double lng = step["end_location"]["lng"].toDouble();
        Coordinates coordinates = Coordinates(latitude: lat , longitude: lng);
        final htmlDirections = parse(step["html_instructions"]);
        final String? parsedString = parse(htmlDirections.body?.text).documentElement?.text;
        String orientation = step["maneuver"] ??= parsedString?.split(" ")[1];
        Waypoint waypoint = Waypoint(distance: distance, end: coordinates, orientation: orientation);
        waypointList.add(waypoint);

      }
      for (final waypoint in waypointList) {
        print(waypoint.toString());
      }

    } catch (e) {
      print(e.toString());
    }
  }




}