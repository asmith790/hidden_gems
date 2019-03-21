import 'package:flutter/material.dart';
import 'homePage.dart';
import 'listingPage.dart';
import 'auth.dart';
import 'rootPage.dart';
import 'loginPage.dart';
import 'mapview.dart';


class StartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hidden Gems',
      //Todo: add theme if we want to here
      home: RootPage(auth: new Auth()),
      initialRoute: '/',
      routes: {
        '/login' : (_) => new Login(),
        '/listings': (_) => new ListingPage(),
        '/maps' : (_) => new MapsDemo(),
      },
    );
  }
}
