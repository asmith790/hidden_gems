import 'package:flutter/material.dart';
import 'navBar.dart';

class Post extends StatefulWidget {
  @override
  _PostState createState() => _PostState();
}
class _PostState extends State<Post>{

  int _counter = 0; //Would be set to the value of upvotes - downvotes

  void increment() {
    setState(() {
      _counter++;
      //update database
    });
  }

  void decrement() {
    setState(() {
      _counter--;
      //update database
    });
  }

  //Rerun every time setState is called
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Hidden Gems')),
      body: Column(
        mainAxisSize: MainAxisSize.max,
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text('Distance Away'),
            ],
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Name'),
                Text('Description'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Tags'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Author'),
                Text('Rating'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(_counter.toString()),
              ],
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            verticalDirection: VerticalDirection.up,
            children: <Widget>[
              Column(
                children: <Widget>[
                  RaisedButton(child: Text('Downvote'), onPressed: () {decrement();},)
                ],
              ),
              Column(
                children: <Widget>[
                  RaisedButton(child: Text('Upvote'), onPressed: () {increment();},)
                ],
              )
            ],
          )
        ],
      ),
      drawer: MyDrawer(),
    );
  }
}
