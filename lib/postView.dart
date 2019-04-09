import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navBar.dart';
import 'post.dart';
import 'voteTracker.dart';

class PostView extends StatelessWidget {
  final String id;
  PostView({this.id});
  List<Post> posts;

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
                      .map((document) => new Post(
                      description: document["description"],
                      name: document["name"],
                      tags: document["tags"].toString(),    //Update this to the tag thing Sami is using
                      rating: document["rating"],
                      userid: document["userid"],
                      imgUrl: document["picture"],
                  ))
                      .toList();
                  return new Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Image.network(
                              posts[0].imgUrl,
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
                      VoteTracker(count: posts[0].rating, postId: id,),
                    ],
                  );
              }
            },
          ),
        ],
      ),
      ),
      drawer: MyDrawer(),
    );
  }
}