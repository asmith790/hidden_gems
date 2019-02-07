import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navBar.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
//  final appTitle = 'Hidden Gems';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hidden Gems',
      home: MyHomePage(title: 'Hidden Gems'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hidden Gems')),
      body: Center(child: Text('My Page!')),
      drawer: MyDrawer(),
    );
  }
}