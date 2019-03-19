import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'auth.dart';

class StartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hidden Gems',
      //Todo: add theme if we want to here
      home: Login(auth: new Auth()),
    );
  }
}
