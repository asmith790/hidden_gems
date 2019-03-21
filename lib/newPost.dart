import 'dart:io';

import 'package:flutter/material.dart';
import 'firebase_firestore_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class ShowHideTextField extends StatefulWidget {
  @override
  NewPost createState() {
    return new NewPost();
  }
}
class CustomForm extends StatefulWidget {
  @override
  NewPost createState() => NewPost();
}
class NewPost extends State<CustomForm> {
  FirebaseFirestoreService db = new FirebaseFirestoreService();
  @override
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _tagsController = TextEditingController();
  final _gpsController = TextEditingController();
  final _useridController = TextEditingController();
  final _pictureController = TextEditingController();
  var uuid = new Uuid();
  File image;
  var imgUrl;

  bool _isTextFieldVisible = false;
  bool finished = true;
  List <String> tags = new List();
  int rating = 1;

  Future selectImage() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = img;
    });
  }

  removeImage(){
    setState(() {
      image = null;
    });
  }

  uploadGem() async {
    //Upload Image to Storage and get download URL
    var imgUrl = "";
    if(image!=null) {
      String imgTitle = uuid.v1() + ".jpg";
      final StorageReference firebaseStorRef = FirebaseStorage.instance.ref().child(imgTitle);
      final StorageUploadTask task = firebaseStorRef.putFile(image);
      imgUrl = await(await task.onComplete).ref.getDownloadURL();
    }

    //Upload Gem to DB
    db.createGem(_nameController.text, _descriptionController.text, tags, _gpsController.text, _useridController.text, imgUrl, finished, rating).then((_) {
      _nameController.clear();
      _descriptionController.clear();
      _tagsController.clear();
      Navigator.pop(context);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
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
              onSubmitted: (text) {
                setState(() {
                  tags.add(text);
                });
              },
            ),
            ),

            Row(
              children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
              child: FloatingActionButton(
                  onPressed: selectImage,
                  tooltip: 'Upload Image',
                  child: new Icon(Icons.add_a_photo)
              ),
            ),

            image != null ? Text("Picture Uploaded!"): SizedBox(),

            image != null ? FlatButton(
                onPressed: removeImage,
                child: new Icon(Icons.cancel, color: Color.fromRGBO(255, 0, 0, 1)),
                //color: Color.fromRGBO(0, 0, 0, 0),
            ): SizedBox(),

           ]),

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
              onPressed: uploadGem,
            ),

            Padding(padding: new EdgeInsets.all(5.0)),
            RaisedButton(
              child: Text('Save as Draft'),
              onPressed: () {
                finished = false;
                uploadGem();
              },
            ),
          ],
        ),
      ),
    );
  }
}