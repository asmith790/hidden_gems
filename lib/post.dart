import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navBar.dart';
import 'Listing.dart';

//I think the counter alone needs to be in a stateful widget and that is in a
//parent widget with the other stuff that is stateless. So only the counter changes.
class Post extends StatefulWidget {
  final String id;
  int count;
  Post({this.id});

  Container postDetails() {

    return Container(
        child: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('posts')
          .where("id", isEqualTo: id)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Center(child: new CircularProgressIndicator());
          default:
            List<Listing> posts = snapshot.data.documents
                .map((document) => new Listing(
                    description: document["description"],
                    name: document["name"],
                    tags: document["tags"].toString(),
                    upvotes: document["rating"][1],
                    downvotes: document["rating"][0],
                    userid: document["userid"]))
                .toList();
            count = posts[0].upvotes - posts[0].downvotes;
            return new Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        'assets/map.png',
                        width: MediaQuery.of(context).size.width,
                        height: 240,
                      ), //To be replaced with google map/photo of gem
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
                    Text(
                      posts[0].name,
                      style: TextStyle(
                          fontSize: 24.0, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(posts[0].description),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(posts[0].tags),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(posts[0].userid),
                  ],
                ),
              ],
            );
        }
      },
    ));

  }

  @override
  _PostState createState() => _PostState(count);
}

class _PostState extends State<Post> {
  int _counter; //Would be set to the value of upvotes - downvotes

  _PostState(num counter) {
    _counter = counter;
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

  Row setCounter() {
    return Row(children: <Widget>[
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

  //Rerun every time setState is called
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Hidden Gems')),
      body: Column(
        children: <Widget>[
          widget.postDetails(),
          setCounter(),
        ],
      ),
      drawer: MyDrawer(),
    );
  }
}
