import 'package:flutter/material.dart';
import 'package:roam_assist/widgets/coordinate_input.dart';
import 'package:roam_assist/models/coordinates.dart';
import 'package:roam_assist/widgets/coordinates_list.dart';

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

  String selectedValue = "Select your map";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 100,
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: DropdownButton(
                value: selectedValue,
                borderRadius: BorderRadius.circular(20),
                style: TextStyle(
                    color: Colors.black, fontSize: 20, fontFamily: 'Poppins'),
                focusColor: const Color.fromARGB(255, 212, 211, 211),
                isExpanded: true,
                dropdownColor: const Color.fromARGB(255, 212, 211, 211),
                items: dropdownItems,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value.toString();
                  });
                },
              )),
          SizedBox(
            height: 100,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 52, right: 59),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Longitude', style: TextStyle(fontSize: 20),), Text('Latitude', style: TextStyle(fontSize: 20),)],
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
            margin: const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
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
    );
    ;
  }
}
