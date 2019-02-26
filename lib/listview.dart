import 'package:flutter/material.dart';
import 'navBar.dart';

class ListV extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Hidden Gems')),
      body: Column(
        children: <Widget>[
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/map.png', width: MediaQuery.of(context).size.width, height: 240,
                ),  //To be replaced with google map/photo of gem
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Post Count'),
            ],
          )
        ],
      ),
      drawer: MyDrawer(),
    );
  }
}
