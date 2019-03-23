import 'package:flutter/material.dart';
import 'profile.dart';
import 'newPost.dart';
import 'homePage.dart';

class MyDrawer extends StatelessWidget {

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
              Navigator.pop(context);
              /// CHANGED - trying to fix if we can pass root as a widget, so calling Home instead of Root
              Navigator.pushNamed(context, '/');
//              Navigator.push(
//                context,
//                new MaterialPageRoute(builder: (context) => new HomePage()),
//              );
            },
          ),
          ListTile(
            title: Text('List View'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
              Navigator.pushNamed(context, '/listings');
            },
          ),
          ListTile(
            title: Text('Map View'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/maps');
            },
          ),
          ListTile(
            title: Text('Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new Profile()),
              );
            },
          ),
          ListTile(
            title: Text('New Post'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new CustomForm()),
              );
            },
          ),
//          ListTile(
//            title: Text('Logout'),
//            onTap: () {
//              Navigator.pop(context);
//              Navigator.push(
//                context,
//                new MaterialPageRoute(builder: (context) => new CustomForm()),
//              );
//            },
//          ),

        ],
      ),
    );
  }
}
