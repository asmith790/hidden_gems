import 'package:flutter/material.dart';
import 'navBar.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Hidden Gems')),
      body: Column(
        children: <Widget>[
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
                child: FittedBox(
                  fit: BoxFit.contain, // otherwise the logo will be tiny
                  child: const FlutterLogo(),
                ),
            ),
            Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Name Test'),
                      Text('Username'),
                      Text('Rating'),
                    ],
                  ),
            ),
          ],
        ),
      ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('My Gems'),
          ],
          ),
    ],
      ),

      drawer: MyDrawer(),
    );
  }
}
