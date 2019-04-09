import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'navBar.dart';

class User{
  final String userId, username, name, email, bio , imageUrl;
  const User({
    this.userId,
    this.username,
    this.name,
    this.email,
    this.bio,
    this.imageUrl,
  });
}

class ProfileEdit extends StatefulWidget {
  final User value;
  ProfileEdit({Key key, this.value}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ProfileEdit();
}

class _ProfileEdit extends State<ProfileEdit> {
  String _userId;
  String _email = ' ';
  String _username = ' ';
  String _name = ' ';
  String _bio = ' ';
  String _picture = ' ';
  int _rating = 0;

  @override
  void initState() {
    super.initState();
    _userId = widget.value.userId;
    _email = widget.value.email;
    _username = widget.value.username;
    _name = widget.value.name;
    _bio = widget.value.bio;
    _picture = widget.value.imageUrl;
    print('UserId on Edit Page:' + _userId);
  }

  _submitBio(){
    var batch = Firestore.instance.batch();
    var currUser = Firestore.instance.collection('users').document(_userId);
    batch.updateData(currUser, {
      'bio': _bio,
    });
    batch.commit().then((val) {
      print(_bio);
      Fluttertoast.showToast(
          msg: "Successfully changed bio",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return true; // successful
    }).catchError((err){
      print('Error: $err');
      Fluttertoast.showToast(
          msg: "Error: was not able to change bio",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return false;
    });
  }

  File image;

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

  _uploadPicture() async{
    //Upload Image to Storage and get download URL
    var _imgUrl = "";
    if(image!=null) {
      String imgTitle = _username + ".jpg";
      final StorageReference firebaseStorRef = FirebaseStorage.instance.ref().child(imgTitle);
      final StorageUploadTask task = firebaseStorRef.putFile(image);
      _imgUrl = await(await task.onComplete).ref.getDownloadURL();
    }
    if(_imgUrl != null){
      var batch = Firestore.instance.batch();
      var currUser = Firestore.instance.collection('users').document(_userId);
      batch.updateData(currUser, {
        'picture': _imgUrl,
      });
      batch.commit().then((val) {
        Fluttertoast.showToast(
            msg: "Successfully changed profile picture",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 2,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0
        );
        return true; // successful
      }).catchError((err){
        print('Error: $err');
        Fluttertoast.showToast(
            msg: "Error: was not able to upload profile picture",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 2,
            backgroundColor: Colors.black54,
            textColor: Colors.white,
            fontSize: 16.0
        );
        return false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _simplePadding(),
            Center(
              child: Text(
                'Edit Bio:',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  fontSize: 20.0,
                ),
              ),
            ),
            _simplePadding(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                onChanged: (text) {
                  _bio = text;
                },
                decoration: InputDecoration(
                    border: OutlineInputBorder()
                ),
              ),
            ),
            _simplePadding(),
            RaisedButton(
              padding: const EdgeInsets.all(8.0),
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: _submitBio,
              child: new Text("Submit"),
            ),
            _simplePadding(),
            Divider(
              height: 2.0,
              color: Colors.grey,
            ),
            _simplePadding(),
            Center(
              child: Text(
                'Add or Change Profile Image:',
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  fontSize: 20.0,
                ),
              ),
            ),
            _simplePadding(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
              child: FloatingActionButton(
                  onPressed: selectImage,
                  tooltip: 'Upload Image',
                  child: new Icon(Icons.add_a_photo)
              ),
            ),
            Center(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 80.0)
                  ),
                  Expanded(child: image != null ? Text("Picture Selected!"): SizedBox()),
                  Expanded(child:image != null ? FlatButton(
                    onPressed: removeImage,
                    child: new Icon(Icons.cancel, color: Color.fromRGBO(255, 0, 0, 1)),
                    //color: Color.fromRGBO(0, 0, 0, 0),
                  ): SizedBox()),
                ],
              ),
            ),
            RaisedButton(
              padding: const EdgeInsets.all(8.0),
              textColor: Colors.white,
              color: Colors.blue,
              onPressed: _uploadPicture,
              child: new Text("Submit"),
            ),
          ],
        ),
      )
    );
  }

  //--------------Widgets-------------
  Padding _simplePadding(){
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
    );
  }
}