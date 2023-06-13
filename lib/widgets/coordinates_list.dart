import 'package:flutter/material.dart';
import 'package:roam_assist/models/coordinates.dart';

class CoordinatesList extends StatefulWidget {
  List<Coordinates> coord_list;

  CoordinatesList({required this.coord_list});

  @override
  State<CoordinatesList> createState() => _CoordinatesListState();
}

class _CoordinatesListState extends State<CoordinatesList> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 50, right: 50),
      child:
          ListView.builder(itemBuilder: (context, index) {
            if (index < widget.coord_list.length) {
              return CoordinateTile(longitude: widget.coord_list[index].longitude, latitude: widget.coord_list[index].latitude);
            }
          }),
    );
  }
}

// Row(
//   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   children: [
//     Text('Longitude'),
//     Text('Latitude'),
//   ],
// ),

class CoordinateTile extends StatelessWidget {

  double longitude;
  double latitude;

  CoordinateTile({required this.longitude, required this.latitude});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(longitude.toString(),
        style: TextStyle(fontSize: 15),
        ),
      trailing: Text(latitude.toString(), style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),),
    );
  }
}
