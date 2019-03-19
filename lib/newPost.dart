import 'package:flutter/material.dart';
import 'firebase_firestore_service.dart';

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
  final _gpsController = TextEditingController();
  final _useridController = TextEditingController();
  final _pictureController = TextEditingController();

  bool _isTextFieldVisible = false;
  bool finished = true;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposeed
    _nameController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    _gpsController.dispose();
    _useridController.dispose();
    _pictureController.dispose();
    super.dispose();
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
            ),
            ),

            _isTextFieldVisible ?
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: _gpsController,
                decoration: InputDecoration(labelText: 'GPS'),
              ),
            ): SizedBox(),

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
                  db.createGem(_nameController.text, _descriptionController.text, _tagsController.text, _gpsController.text, _useridController.text, _pictureController.text, finished).then((_) {
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
                finished = false;
                db.createGem(_nameController.text, _descriptionController.text, _tagsController.text, _gpsController.text, _useridController.text, _pictureController.text, finished).then((_) {
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