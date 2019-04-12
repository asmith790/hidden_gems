import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class EditPost extends StatefulWidget {
  final String username;
  final String id;
  EditPost({this.id, this.username});

  @override
  State<StatefulWidget> createState() => new _EditPost();
}
class _EditPost extends State<EditPost> {
  final _formKey = GlobalKey<FormState>();

  String _username;
  String _documentId;
  ///post info
  String _postName;
  String _postUsername;
  String _postDescription; // user can edit
  String _postPicture; // user can edit
  List <dynamic> _postTags = new List(); // user can edit

  File _image;
  var uuid = new Uuid();
  bool _isTextFieldVisible = false;
  bool _finished = true;

  TextEditingController _descriptionController;
  final _pictureController = TextEditingController();


  @override
  void initState() {
    _username = widget.username;
    _documentId = widget.id;
    print(_username + " " + _documentId);
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    _descriptionController.dispose();
    _pictureController.dispose();
    super.dispose();
  }

  selectImage() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  removeImage() {
    setState(() {
      _image = null;
    });
  }

  ///Updating gem in database
  updateGem() async{
    ///Upload Image to Storage and get download URL
    String imgUrl = _postPicture;
    if (_image != null) {
      String imgTitle = uuid.v1() + ".jpg";
      final StorageReference fireBaseStorageReference = FirebaseStorage.instance.ref()
          .child(imgTitle);
      final StorageUploadTask task = fireBaseStorageReference.putFile(_image);
      imgUrl = await(await task.onComplete).ref.getDownloadURL();
    }
    var batch = Firestore.instance.batch();
    var currUser = Firestore.instance.collection('posts').document(_documentId);
    batch.updateData(currUser, {
      'description':  _descriptionController.text,
      'picture': imgUrl,
      //TODO: update the new tags list
    });
    batch.commit().then((val) {
      print(_postDescription);
      Fluttertoast.showToast(
          msg: "Successfully updated Gem",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 2,
          backgroundColor: Colors.black54,
          textColor: Colors.white,
          fontSize: 16.0
      );
      Navigator.pop(context); //pop off page when done
      return true; // successful
    }).catchError((err){
      print('Error: $err');
      Fluttertoast.showToast(
          msg: "Error: was not able to update Gem",
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

  /// Display all tags already in the database
  String _displayTags(){
    String temp = 'Tags: \n';
    for(int i = 0; i < _postTags.length; i++){
      if(i%5 == 0){
        temp = temp + '\n';
      }
      temp = temp + '  ' + _postTags[i];
    }
    return temp;
  }

  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(title: Text('Hidden Gems')),
        body: SingleChildScrollView(
          child: FutureBuilder<void>(
              future: Firestore.instance.collection('posts').document(_documentId).get().then((doc){
                if(doc.exists){
                  _postName = doc.data['name'];
                  _postUsername = doc.data['userid'];
                  _postDescription = doc.data['description'];
                  _postPicture = doc.data['picture'];
                  _postTags = doc.data['tags'];
                  _descriptionController = TextEditingController(text: doc.data['description']);
                  print(_postTags);
                }
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return new Center(child: new CircularProgressIndicator());
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return new Text('${snapshot.error}');
                  } else {
                    return _buildPage(context);
                  }
                }
              }
          ),
        )
    );
  }

  Widget _buildPage(BuildContext context){
    return Container(
      margin: EdgeInsets.all(15.0),
      alignment: Alignment.center,
      child: Builder(
        builder: (context) => Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.fromLTRB(25.0,10,25,25),
                child: Text(
                  "Edit Gem $_postName!",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: TextFormField(
                  controller: _descriptionController,
                  maxLength: 35,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
              ),
//              Padding(
//                padding: EdgeInsets.symmetric(horizontal: 25.0),
//                child: TextFormField(
////                  controller: _tagsController,
//                  decoration: InputDecoration(labelText: 'Tags',
//                      suffixIcon: IconButton(
//                        icon: Icon(Icons.add),
//                        color: Colors.blue,
//                        onPressed: () {
////                          _postTags.add(_tagsController.text);
////                          this.setState(() {
////                            _tagsController.clear();
////                          });
////                          },
//                        )),
//                  ),
//                ),
              Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    _displayTags(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                    ),
                  ),
                ),
              Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 0.0),
                      child: FloatingActionButton(
                          onPressed: selectImage,
                          tooltip: 'Upload Image',
                          child: new Icon(Icons.add_a_photo)
                      ),
                    ),
                    _image != null ? Text("Picture Uploaded!") : SizedBox(),

                    _image != null ? FlatButton(
                      onPressed: removeImage,
                      child: new Icon(
                          Icons.cancel, color: Color.fromRGBO(255, 0, 0, 1)),
                    ) : SizedBox(),

                  ]),
              _isTextFieldVisible ?
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: _pictureController,
                    decoration: InputDecoration(labelText: 'Picture'),
                  ),
              ) : SizedBox(),
              SizedBox(
                height: 25.0,
              ),
              RaisedButton(
                child: Text(
                  'Submit Changes',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                color: Colors.blue,
                textColor: Colors.white,
                padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0, bottom: 20.0),
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(2.0)
                ),
                onPressed: () {
                  //TODO: add new tags or delete previous ones???
                  updateGem();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}