import 'package:flutter/material.dart';
import 'firebase_firestore_service.dart';
import 'package:geolocator/geolocator.dart';

class ShowHideTextField extends StatefulWidget {
  @override
  Post createState() {
    return new Post();
  }
}
class CustomForm extends StatefulWidget {
  @override
  Post createState() => Post();
}
class Post extends State<CustomForm> {
  FirebaseFirestoreService db = new FirebaseFirestoreService();
  @override
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final _useridController = TextEditingController();
  final _pictureController = TextEditingController();

  bool _isTextFieldVisible = false;
  bool finished = true;
  List <String> tags = new List();
  int rating = 0;
  Geolocator geolocator = Geolocator();
  Position userLocation;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposeed
    _nameController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
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

  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text('Add a New Gem!')),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            ),

            Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            ),

            Padding(
            padding: EdgeInsets.symmetric(horizontal: 25.0),
            child: TextField(
              controller: _tagsController,
              decoration: InputDecoration(labelText: 'Tags'),
              onSubmitted: (text) {
                setState(() {
                  tags.add(text);
                });
              },
            ),
            ),

            _isTextFieldVisible ?
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: _useridController,
                decoration: InputDecoration(labelText: 'UserId'),
              ),
            ): SizedBox(),

            _isTextFieldVisible ?
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: _pictureController,
                decoration: InputDecoration(labelText: 'Picture'),
              ),
            ): SizedBox(),

            SizedBox(
              height: 25.0,
            ),

            Padding(padding: new EdgeInsets.all(5.0)),
            RaisedButton(
              child: Text('Add'),
              onPressed: () {
                locateUser().then((value) {
                  setState(() {
                    userLocation = value;
                  });
                });
                finished = true;
                db.createGem(_nameController.text, _descriptionController.text, tags, userLocation.longitude, userLocation.latitude, _useridController.text, _pictureController.text, finished, rating).then((_) {
                    _nameController.clear();
                    _descriptionController.clear();
                    _tagsController.clear();
                  });

              },
            ),

            Padding(padding: new EdgeInsets.all(5.0)),
            RaisedButton(
              child: Text('Save as Draft'),
              onPressed: () {
                locateUser().then((value) {
                  setState(() {
                    userLocation = value;
                  });
                });

                finished = false;
                db.createGem(_nameController.text, _descriptionController.text, tags, userLocation.longitude , userLocation.latitude, _useridController.text, _pictureController.text, finished, rating).then((_) {
                  _nameController.clear();
                  _descriptionController.clear();
                  _tagsController.clear();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

}