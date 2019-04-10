import 'package:flutter/material.dart';
import 'navBar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsDemo extends StatefulWidget {
  final String username;
  MapsDemo({Key key, this.username}) : super(key: key);

  @override
  State createState() => MapV();
}
class MapV extends State<MapsDemo> {
  @override
  GoogleMapController mapController;


  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Hidden Gems')),
      body: ListView(
        children: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.end,
//            children: <Widget>[
//              Text('Top of Map'),
//            ],
//          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Center(
                child: SizedBox(
                  width: 400.0,
                  height: 600.0,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
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
      drawer: MyDrawer(value: widget.username),
    );
  }
  void _onMapCreated(GoogleMapController controller) {
    setState(() { mapController = controller; });
  }
}
