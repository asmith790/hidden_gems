import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'profile.dart';
import 'voteTracker.dart';
import 'mapview.dart';
import 'listView.dart';
import 'newPost.dart';

import 'homePage.dart';
import 'auth.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  void _signOut() async{
    try{
      await auth.signOut();
      onSignedOut(); // call voidCallback function
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 75.0,
            child: DrawerHeader(
              child: Text('Menu', style: TextStyle(color: Colors.white)),
              decoration: BoxDecoration(
                  color: Colors.pinkAccent
              ),
            ),
          ),
          ListTile(
            title: Text('Home Page'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new HomePage(auth: auth)),
              );
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('List View'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new listView()),
              );
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Map View'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new MapsDemo()),
              );
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.push(
                context,
                // TODO: currently the Profile Page breaks the system
                new MaterialPageRoute(builder: (context) => new Profile()),
              );
              //Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('New Post'),
            onTap: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new CustomForm()),
              );
              //Navigator.pop(context);
            },
          ),
          FlatButton(
            child:new Text(
                'Logout',
                style: new TextStyle(
                    fontSize: 15.0,
                    color: Colors.black
                )
            ),
            onPressed: _signOut,
          )
        ],
      ),
    );
  }
}