import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navBar.dart';
import 'post.dart';
import 'listingPage.dart';

class ListQuery extends StatefulWidget {

  @override
  State createState() => new ListQueryState();
}

class ListQueryState extends State<ListQuery> {
  Stream query;

  void initState() {
    // TODO: implement initState
    super.initState();
    query = Firestore.instance.collection('posts').where("finished", isEqualTo: true).snapshots();
    super.initState();
  }

  List<Post> posts = new List<Post>();

//Place posts from Query into here
  List<Post> getPosts(AsyncSnapshot<QuerySnapshot> snapshot) {
    List<Post> queryPosts;
    queryPosts = snapshot.data.documents
        .map((document) =>
    new Post(
      description: document["description"],
      name: document["name"],
      tags: document["tags"].toString(),
      rating: document["rating"],
      userid: document["userid"],
      imgUrl: document["picture"],
      id: document.documentID,
    )).toList();

    //TODO: numbers.sort((num1, num2) => num1 - num2); // => [1, 2, 3, 4, 5] -- try sorting by distance
    return queryPosts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hidden Gems')),
      body: StreamBuilder<QuerySnapshot>(
          stream: query,
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new CircularProgressIndicator();
              default:
                posts = getPosts(snapshot);
                return new ListingPage(posts: posts);
            }
          },
        ),
      drawer: MyDrawer(),
    );
  }
}