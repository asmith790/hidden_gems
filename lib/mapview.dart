import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class MapsDemo extends StatefulWidget {
  @override
  State createState() => MapV();
}
class MapV extends State<MapsDemo> {
  @override
  GoogleMapController mapController;

  Geolocator geolocator = Geolocator();
  Position userLocation;

  @override
  void initState() {
    super.initState();
    locateUser().then((position) {
      userLocation = position;
    });
  }

  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((location) {
      if (location != null) {
        print("Location: ${location.latitude},${location.longitude}");
      }
      return location;
    });
  }

  void _updateMarkers() {
      Firestore.instance.collection('posts')
          .where("finished", isEqualTo: true)
          .snapshots()
          .listen((data) =>
          //data.documents.forEach((doc) => print(doc["position"])));
          //data.documents.forEach((doc) => allMarkers.add(doc["position"]))
      data.documents.forEach((doc) => mapController.addMarker(MarkerOptions(
        position: LatLng(doc["position"].latitude, doc["position"].longitude),
        infoWindowText: InfoWindowText(doc["name"],doc['description']),
      )))
      );
          //print(allMarkers);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Map View'),
          backgroundColor: Colors.green[700],
        ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          locateUser().then((value) {
            setState(() {
              userLocation = value;
            });
          });
          //center = LatLng(userLocation.latitude,userLocation.longitude);
        }),
        body: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
            _updateMarkers();
            },
          options: GoogleMapOptions(
            scrollGesturesEnabled: true,
            myLocationEnabled: true,
            compassEnabled: true,
            cameraPosition: CameraPosition(
              target: LatLng(29.6516,-82.3248),
              //target: LatLng(userLocation.latitude,userLocation.longitude),
              zoom: 11.0,
            ),
          ),
        ),

    )
    );
    }
  }