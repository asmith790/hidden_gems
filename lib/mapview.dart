import 'package:flutter/material.dart';
import 'navBar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsDemo extends StatefulWidget {
  @override
  State createState() => MapV();
}
class MapV extends State<MapsDemo> {
  @override
  GoogleMapController mapController;
  //static const LatLng _center = const LatLng(29.6516, -82.3248);
  static final CameraPosition _center = CameraPosition(
    target: LatLng(29.6516, -82.3248),
    zoom: 30,
  );
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Map View')),
      body: ListView(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: 400.0,
                  height: 600.0,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    options: GoogleMapOptions(
                      scrollGesturesEnabled: true,
                      cameraPosition: _center,
                    ),
                  ),
                ),
              )
            ],
          ),
//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Text('Bottom of Map'),
//            ],
//          )
        ],
      ),
      drawer: MyDrawer(),
    );
  }
  void _onMapCreated(GoogleMapController controller) {
    setState(() { mapController = controller; });
  }
}
