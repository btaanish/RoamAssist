import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roam_assist/views/coordinates_screen.dart';
import 'package:roam_assist/views/gps_screen.dart';
import 'package:roam_assist/views/home_screen.dart';
import 'package:roam_assist/views/lidar_screen.dart';
import 'package:roam_assist/views/livelocation_screen.dart';
import 'package:roam_assist/views/main_screen.dart';
import 'package:roam_assist/views/splash_screen.dart';
import 'models/coordinates_data.dart';
import 'models/location_data.dart';
import 'views/map_screen.dart';
import 'package:roam_assist/views/take_me_there_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocationData(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => LocationData()),
        ChangeNotifierProvider(create: (context) => CoordinatesData()),
      ],
      child: MaterialApp(
        title: 'Roam Assist',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: 'splash_screen',
        routes: {
          'splash_screen': (context) => const SplashScreen(),
          'home_screen': (context) => const HomeScreen(),
          'main_screen':(context) => const MainScreen(),
          'coordinates_screen':(context) => const CoordinatesScreen(),
          'livelocation_screen': (context) => const LiveLocationScreen(),
          'gps_screen': (context) => const GpsScreen(),
          'lidar_screen': (context) => const LidarScreen(),
        },
      ),
    );
  }
}

