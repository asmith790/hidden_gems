import 'package:flutter/material.dart';
import 'auth.dart';
import 'rootPage.dart';

class StartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hidden Gems',
      //Todo: add theme if we want to here
      home: RootPage(auth: new Auth()),
    );
  }
}
