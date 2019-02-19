import 'package:flutter/material.dart';
import 'profile.dart';
import 'post.dart';
import 'main.dart';
import 'listView.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
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
              title: Text('List View'),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new listView()),
                );
//                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Map View'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Post View //Testing'),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new Post()),
                );
                //Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new Profile()),
                );
                //Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Logout'),
              onTap: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (context) => new MyHomePage()),
                );
                //Navigator.pop(context);
              },
            ),
          ],
        ),
    );
  }
}