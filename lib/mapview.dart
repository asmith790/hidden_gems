import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MapsDemo extends StatefulWidget {
  @override
  State createState() => MapV();
}
class MapV extends State<MapsDemo> {
  @override
  GoogleMapController mapController;
  static const LatLng _center = const LatLng(29.6516, -82.3248);

 // List <GeoPoint> allMarkers;

  void _updateMarkers() {
      Firestore.instance.collection('posts')
          .where("finished", isEqualTo: true)
          .snapshots()
          .listen((data) =>
          //data.documents.forEach((doc) => print(doc["position"])));
          //data.documents.forEach((doc) => allMarkers.add(doc["position"]))
      data.documents.forEach((doc) => mapController.addMarker(MarkerOptions(
        position: LatLng(doc["position"].latitude, doc["position"].longitude),
      )))
      );
          //print(allMarkers);
  }

//  void marker() {
//    mapController.addMarker(
//      MarkerOptions(
//        //icon: BitmapDescriptor.fromAsset("assets/gemicon.bmp"),
//        //position: LatLng(29.6516, -82.3248),
//        position: LatLng(allMarkers[0].latitude, allMarkers[0].longitude),
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Map View'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
            _updateMarkers();
            //marker();
          },
          options: GoogleMapOptions(
            scrollGesturesEnabled: true,
            tiltGesturesEnabled: true,
            rotateGesturesEnabled: true,
            myLocationEnabled: true,
            compassEnabled: true,
            cameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
          ),
        ),
        )
      );
  }

}
