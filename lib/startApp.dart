import 'package:flutter/material.dart';
import 'auth.dart';
import 'authProvider.dart';
import 'rootPage.dart';
import 'loginPage.dart';
import 'profile.dart';
import 'listingPage.dart';
import 'mapview.dart';
import 'newPost.dart';


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
          '/profile' :(_) => new Profile(),
          '/listings': (_) => new ListingPage(),
          '/maps' : (_) => new MapsDemo(),
          '/post' : (_) => new CustomForm(),
          //TODO: add all the other routes here
        },
      )
    );
  }
}
