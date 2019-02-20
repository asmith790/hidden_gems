import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navBar.dart';
import 'Listing.dart';
import 'post.dart';
//I think the counter alone needs to be in a stateful widget and that is in a
//parent widget with the other stuff that is stateless. So only the counter changes.
class test extends StatelessWidget {
  final String id;
  test({this.id});
  int count;
  List<Listing> posts;

  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Hidden Gems')),
      body: SingleChildScrollView(
    child: Column(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
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
                  posts = snapshot.data.documents
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
          ),
          Post(count: count),
        ],
      ),
      ),
      drawer: MyDrawer(),
    );
  }
}