import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VoteTracker extends StatefulWidget {
  final int count;
  final String postId;
  final String currUser;
  final int currVote;

  VoteTracker({this.count, this.postId, this.currUser, this.currVote});

  @override
  _VoteTrackerState createState() => _VoteTrackerState(count, postId, currUser, currVote);
}

class _VoteTrackerState extends State<VoteTracker> {
  int _counter;
  String _postId;
  String _currentUser;
  int _currentVote;

  //constructor
  _VoteTrackerState(int count, String postId, String currUser, int currVote) {
    _counter = count;
    _postId = postId;
    _currentUser = currUser;
    _currentVote = currVote;
  }

  increment(String id) {
    Firestore.instance.collection('posts').document(id).updateData({'rating': _counter + 1});

    setState(() {
      _counter++;
    });
  }

  decrement(String id) {
    Firestore.instance.collection('posts').document(id).updateData({'rating': _counter -1});
    
    setState(() {
      _counter--;
    });
  }

  changeCurrVote(){
    Firestore.instance.collection('posts').document(_postId).updateData({'voters': {_currentUser: _currentVote}});
  }

  Widget _thumbsUp(){
    //Never Votes
    if(_currentVote == 2) {
      return IconButton(
        icon: Icon(Icons.thumb_up),
        color: Colors.grey,
        iconSize: 40.0,
        onPressed: () {
          increment(_postId);
          _currentVote = 1;
          changeCurrVote();
        },
      );
    }else if(_currentVote == 1) { //Thumbs up
      //darken thumbs up button if voted thumbs up already
      return IconButton(
        icon: Icon(Icons.thumb_up),
        color: Colors.blue,
        iconSize: 40.0,
        onPressed: () {
          decrement(_postId);
          _currentVote = 2;
          changeCurrVote();
        },
      );
    }else if(_currentVote == -1){
      //disable thumbs up button for own post
      return IconButton(
        icon: Icon(Icons.thumb_up),
        color: Colors.grey,
        iconSize: 40.0,
        onPressed: null,
      );
    }else{
      // can thumbs up , change currentVal = 1
      return IconButton(
        icon: Icon(Icons.thumb_up),
        color: Colors.grey,
        iconSize: 40.0,
        onPressed: () {
          increment(_postId);
          increment(_postId);
          _currentVote = 1;
          changeCurrVote();
        },
      );
    }
  }

  Widget _thumbsDown(){
    if(_currentVote == 2){
      return IconButton(
        icon: Icon(Icons.thumb_down),
        color: Colors.grey,
        iconSize: 40.0,
        onPressed: () {
          decrement(_postId);
          _currentVote = 0;
          changeCurrVote();
        },
      );
    } else if(_currentVote == 0){
      //Already pushed
      return IconButton(
        icon: Icon(Icons.thumb_down),
        color: Colors.blue,
        iconSize: 40.0,
        onPressed: () {
          increment(_postId);
          _currentVote = 2;
          changeCurrVote();
          },
      );
    }else if(_currentVote == -1){
      //disable thumbs down button for own post
      return IconButton(
        icon: Icon(Icons.thumb_down),
        color: Colors.grey,
        iconSize: 40.0,
        onPressed: null,
      );
    }else{
      // can thumbs down , change currentVal = 0 for user
      return IconButton(
        icon: Icon(Icons.thumb_down),
        color: Colors.grey,
        iconSize: 40.0,
        onPressed: () {
          decrement(_postId);
          decrement(_postId);
          _currentVote = 2;
          changeCurrVote();
        },
      );
    }
  }
  //Rerun every time setState is called
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: VerticalDirection.up,
          children: <Widget>[
            Column(
              children: <Widget>[
                _thumbsUp()
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
                _thumbsDown()
              ],
            ),
          ],
        ),
      ]);
  }
}
