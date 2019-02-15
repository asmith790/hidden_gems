import 'dart:async';
import 'package:flutter/material.dart';
import 'navBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'gem.dart';
import 'firebase_firestore_service.dart';


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

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _nameController.dispose();
    _descriptionController.dispose();
    _tagsController.dispose();
    super.dispose();
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add a New Gem!')),
      body: Container(
        margin: EdgeInsets.all(15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            TextField(
              controller: _tagsController,
              decoration: InputDecoration(labelText: 'Tags'),
            ),
            Padding(padding: new EdgeInsets.all(5.0)),
            RaisedButton(
              child: Text('Add'),
              onPressed: () {
                  db.createGem(_nameController.text, _descriptionController.text, _tagsController.text).then((_) {
                    Navigator.pop(context);
                  });
              },
            ),
          ],
        ),
      ),
    );
  }
}