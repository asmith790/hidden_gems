import 'package:flutter/material.dart';
import 'navBar.dart';

class Profile extends StatelessWidget {
  @override
  Widget build (BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Hidden Gems')),
      body: Center(child: Text('Profile!')),
      drawer: MyDrawer(),
    );
  }
}