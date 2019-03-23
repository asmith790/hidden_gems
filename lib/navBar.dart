import 'package:flutter/material.dart';
import 'newPost.dart';

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
            title: Text('Profile'),
            onTap: () {
              // TODO: IDEA: can just pop until first profile page instead of calling root
              Navigator.pop(context);
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            title: Text('List View'),
            onTap: () {
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
            title: Text('New Post'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new CustomForm()),
              );
            },
          ),
        ],
      ),
    );
  }
}
