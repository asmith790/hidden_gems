import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navBar.dart';
import 'Listing.dart';

//I think the counter alone needs to be in a stateful widget and that is in a
//parent widget with the other stuff that is stateless. So only the counter changes.
class Post extends StatefulWidget {
  final int count;

  Post({this.count});

  @override
  _PostState createState() => _PostState(count);
}

class _PostState extends State<Post> {
  int _counter; //Would be set to the value of upvotes - downvotes
  String id;
  List<Listing> posts;

  _PostState(int count) {
    _counter = count;
  }

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
    return new Column(
      children: <Widget>[
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
                RaisedButton(
                  child: Text('Downvote'),
                  onPressed: () {
                    decrement();
                  },
                )
              ],
            ),
            Column(
              children: <Widget>[
                RaisedButton(
                  child: Text('Upvote'),
                  onPressed: () {
                    increment();
                  },
                )
              ],
            )
          ],
        )
      ]);
  }
}
