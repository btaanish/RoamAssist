import 'package:roam_assist/constants.dart';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Column (
        children: [
          //create a rectangular backgrund with broder radius
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: double.infinity,
            decoration: const BoxDecoration(
              // add color gradient background
              color: kSecondaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  const Text(
                    "Roam Assist",
                    style: TextStyle(
                      fontSize: 50.0,
                      color: kTextColor,
                      fontFamily: 'Poppins'
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(bottom: 30.0)),
                  GestureDetector(
                    onTap: () {},
                    child: Image.asset(
                      'assets/images/start.png',
                      height: 50,
                      width: 50,)
                  )
                ],
              ),
            ),
          ),
          

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(30),
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: kTextColor,
                  ),
                  child: Center(
                    child: TextButton(
                      onPressed: () async {
                        
                      },
                      child: const Text('Stand',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                      ),
                      ),
                    ),
                  ),
              ),

              Container(
                  margin: const EdgeInsets.all(30),
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: kTextColor,
                  ),
                  child: Center(
                    child: TextButton(
                      onPressed: () async {
                        
                      },
                      child: const Text('Sit',
                      style: TextStyle(
                        color: kPrimaryColor,
                        fontSize: 20,
                        fontFamily: 'Poppins',
                      ),
                      ),
                    ),
                  ),
              ),
              ]
            ),
          )
          


        ],
      )
    );
  }
}
