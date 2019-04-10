import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'post.dart';

//I think the counter alone needs to be in a stateful widget and that is in a
//parent widget with the other stuff that is stateless. So only the counter changes.
class VoteTracker extends StatefulWidget {
  final int count;
  final String postId;

  VoteTracker({this.count, this.postId});

  @override
  _VoteTrackerState createState() => _VoteTrackerState(count, postId);
}

class _VoteTrackerState extends State<VoteTracker> {
  int _counter;
  String _postId;

  _VoteTrackerState(int count, String postId) {
    _counter = count;
    _postId = postId;
  }

  Future<bool> increment(String id) {

    Firestore.instance.collection('posts').document(id).updateData({'rating': _counter + 1});

    setState(() {
      _counter++;
      //update database
    });
  }

  Future<bool> decrement(String id) {
    
    Firestore.instance.collection('posts').document(id).updateData({'rating': _counter -1});
    
    setState(() {
      _counter--;
      //update database
    });
  }

  //Rerun every time setState is called
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
//        Row(
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Text(_counter.toString()),
//          ],
//        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: VerticalDirection.up,
          children: <Widget>[
            Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.thumb_down),
                  color: Colors.blue,
                  iconSize: 40.0,
                  onPressed: () {
                    decrement(_postId);
                  },
                )
              ],
            ),
            Text(
                _counter.toString(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: 'Roboto',
                fontSize: 20.0
              ),
            ),
            Column(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.thumb_up),
                  color: Colors.blue,
                  iconSize: 40.0,
                  onPressed: () {
                    increment(_postId);
                  },
                )
              ],
            )
          ],
        )
      ]);
  }
}
