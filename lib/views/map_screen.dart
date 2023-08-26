import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class MapScreen extends StatefulWidget {
  Function addCoordinates;

  MapScreen({required this.addCoordinates});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> _controller = Completer();

  late LatLng chosenCoordinates;

  void setChosenCoordinates(double chosenLat, double chosenLong) {
    setState(() {
      chosenCoordinates = LatLng(chosenLat, chosenLong);
    });
  }

  LocationData? currentLocation;
  LatLng? selectedLocation = const LatLng(0.0, 0.0);


  void getCurrentLocation() async {
    Location location = Location();

    location.getLocation().then((location) {
      setState(() {
        currentLocation = location;
      });
    });

    GoogleMapController googleMapController = await _controller.future;

    location.onLocationChanged.listen((event) {
          (newLoc) {
        currentLocation = newLoc;

        googleMapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(newLoc.latitude!, newLoc.longitude!),
              zoom: 13.5,
            ),
          ),
        );
        setState(() {});
      };
    });
  }

  void _onMapCreated(mapController) {
    _controller.complete(mapController);
  }

  // void setCustomMarkerIcon() {
  //   BitmapDescriptor.fromAssetImage(ImageConfiguration.empty, 'assets/images/cutedogmarker.png').then(
  //       (icon) {
  //         currentLocationIcon = icon;
  //       }
  //   );
  // }

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  // void addCustomIcon() {
  //   BitmapDescriptor.fromAssetImage(const ImageConfiguration(), 'assets/images/cutedogmarker.png').then((value){
  //     setState(() {
  //       markerIcon = value;
  //     });
  //   });
  // }


  @override
  void initState() {
    getCurrentLocation();
    // addCustomIcon();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.white,
      ),
      home: Scaffold(
        appBar: AppBar(
          leading: BackButton(onPressed: () => {Navigator.pop(context)}),
          title: const Text(
            'Map',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 2,
        ),
        body: currentLocation == null
            ? Text('Loading')
            : GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(
                currentLocation!.latitude!, currentLocation!.longitude!),
            zoom: 18.0,
          ),
          onTap: (LatLng latLng) {
            final lat = latLng.latitude;
            final long = latLng.longitude;
            if (lat != null && long != null) {
              setState(() {
                selectedLocation = LatLng(lat, long);
              });
            }
            print(lat);
            widget.addCoordinates(long, lat);
          },
          markers: {
            Marker(
              markerId: MarkerId('currentLocation'),
              icon: markerIcon,
              position: LatLng(currentLocation!.latitude!,
                  currentLocation!.longitude!),
            ),
            Marker(
              markerId: MarkerId('selectedLocation'),
              position: LatLng(selectedLocation!.latitude!,
                  selectedLocation!.longitude!),
            ),
          },
        ),
      ),
    );
  }
}