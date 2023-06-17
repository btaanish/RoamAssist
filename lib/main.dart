import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roam_assist/views/coordinates_screen.dart';
import 'package:roam_assist/views/home_screen.dart';
import 'package:roam_assist/views/main_screen.dart';
import 'package:roam_assist/views/splash_screen.dart';
import 'models/coordinates_data.dart';
import 'views/map_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) { CoordinatesData(); },
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

        },
      ),
    );
  }
}

