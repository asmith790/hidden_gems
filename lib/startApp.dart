import 'package:flutter/material.dart';
import 'auth.dart';
import 'authProvider.dart';

import 'listingPage.dart';
import 'rootPage.dart';
import 'loginPage.dart';
import 'mapview.dart';


class StartApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Auth Provider is the inherited widget for the whole app
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Hidden Gems',
        //Todo: add theme if we want to here
        home: RootPage(),
        initialRoute: '/',
        routes: {
          '/login' : (_) => new Login(),
          '/listings': (_) => new ListingPage(),
          '/maps' : (_) => new MapsDemo(),
          //TODO: add all the other routes here
        },
      )
    );
  }
}
