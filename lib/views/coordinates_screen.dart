import 'package:flutter/material.dart';
import 'package:roam_assist/widgets/coordinate_input.dart';

class Coordinates extends StatefulWidget {
  const Coordinates({super.key});



  @override
  State<Coordinates> createState() => _CoordinatesState();
}

class _CoordinatesState extends State<Coordinates> {

  String selectedValue = "Select your map";

  Widget buildBottomSheet(BuildContext context) {
    return const CoordinateInputScreen();
  }

  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("Select your map"),value: "Select your map"),
      DropdownMenuItem(child: Text("SOC Com 3"),value: "SOC Com 3"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          SizedBox(height: 100,),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: DropdownButton(
                value: selectedValue,
                borderRadius: BorderRadius.circular(20),
                style: TextStyle(color: Colors.black, fontSize: 20, fontFamily: 'Poppins'),
                focusColor: const Color.fromARGB(255, 212, 211, 211),
                isExpanded: true,
                dropdownColor: const Color.fromARGB(255, 212, 211, 211),
                items: dropdownItems,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value.toString();
                  });
                },
              )
          ),
          SizedBox(height: 100,),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(context: context, builder: buildBottomSheet);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 212, 211, 211),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Position 1", style: TextStyle(fontFamily: 'Poppins', fontSize: 20, color: Colors.black)),
                        Spacer(),
                        Icon(Icons.arrow_circle_right, color: Colors.black),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(context: context, builder: buildBottomSheet);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 212, 211, 211),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Position 2", style: TextStyle(fontFamily: 'Poppins', fontSize: 20, color: Colors.black)),
                        Spacer(),
                        Icon(Icons.arrow_circle_right, color: Colors.black),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(context: context, builder: buildBottomSheet);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 212, 211, 211),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Position 3", style: TextStyle(fontFamily: 'Poppins', fontSize: 20, color: Colors.black)),
                        Spacer(),
                        Icon(Icons.arrow_circle_right, color: Colors.black),
                      ],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    showModalBottomSheet(context: context, builder: buildBottomSheet);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 212, 211, 211),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Position 4", style: TextStyle(fontFamily: 'Poppins', fontSize: 20, color: Colors.black)),
                        Spacer(),
                        Icon(Icons.arrow_circle_right, color: Colors.black),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );;
  }
}

