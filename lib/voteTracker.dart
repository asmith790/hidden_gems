import 'package:flutter/material.dart';
import 'post.dart';

//I think the counter alone needs to be in a stateful widget and that is in a
//parent widget with the other stuff that is stateless. So only the counter changes.
class VoteTracker extends StatefulWidget {
  final int count;

  VoteTracker({this.count});

  @override
  _VoteTrackerState createState() => _VoteTrackerState(count);
}

class _VoteTrackerState extends State<VoteTracker> {
  int _counter;

  _VoteTrackerState(int count) {
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
