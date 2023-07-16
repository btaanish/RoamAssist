import 'package:flutter/material.dart';

class GpsScreen extends StatefulWidget {
  const GpsScreen({Key? key}) : super(key: key);

  @override
  State<GpsScreen> createState() => _GpsScreenState();
}

class _GpsScreenState extends State<GpsScreen> {
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
              'GPS',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            elevation: 2,
          ),
        ));
  }
}
