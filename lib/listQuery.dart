import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'navBar.dart';
import 'post.dart';
import 'listingPage.dart';

class ListQuery extends StatefulWidget {

  @override
  State createState() => new ListQueryState();
}

class ListQueryState extends State<ListQuery> {
  Stream query;
  Position userLocation;

  void initState() {
    // TODO: implement initState
    super.initState();
    query = Firestore.instance.collection('posts').where("finished", isEqualTo: true).snapshots();
    locateUser().then((value) {
      setState(() {
        userLocation = value;
      });
    });
    super.initState();
  }

  Future<Position> locateUser() async {
    return Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((location) {
      return location;
    });

  }

  Future<double> distance (double latitude, double longitude){
    double distance;
    Geolocator().distanceBetween(latitude, longitude, userLocation.latitude, userLocation.longitude).then((value){
      distance = value/1609.344;
      return distance;
    });
  }

  List<Post> posts = new List<Post>();

//Place posts from Query into here
  Future<List<Post>> getPosts(AsyncSnapshot<QuerySnapshot> snapshot) async {
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
      latitude: document["position"].latitude,
      longitude: document["position"].longitude,
      )).toList();

    //TODO: numbers.sort((num1, num2) => num1 - num2); // => [1, 2, 3, 4, 5] -- try sorting by distance
    return queryPosts;
  }

  void distances()async{
    for(int i=0; i < posts.length; i++){
      distance(posts[i].latitude, posts[i].longitude).then((value){
        posts[i].distance = value;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if(userLocation == null)
      return new Container();
    else
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
                getPosts(snapshot).then((value){
                  posts = value;
                });
                return new ListingPage(posts: posts);
            }
          },
        ),
      drawer: MyDrawer(),
    );
  }
}