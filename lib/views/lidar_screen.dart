import 'package:flutter/material.dart';

class LidarScreen extends StatefulWidget {
  const LidarScreen({Key? key}) : super(key: key);

  @override
  State<LidarScreen> createState() => _LidarScreenState();
}

class _LidarScreenState extends State<LidarScreen> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.white,
        ),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            leading: BackButton(onPressed: () => {Navigator.pop(context)}),
            title: const Text(
              'Lidar',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            elevation: 2,
          ),
        ));
  }
}
