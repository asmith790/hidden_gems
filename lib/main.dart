import 'package:flutter/material.dart';
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