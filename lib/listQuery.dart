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
  List<Post> posts = new List<Post>();

  /// Place posts from Query into a list of Post Objects
  List<Post> _getPosts(AsyncSnapshot<QuerySnapshot> snapshot){
    List<Post> queryPosts;
    queryPosts = snapshot.data.documents.map((document) =>
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
    return queryPosts;
  }

  /// Calculates the distance of current location with the posts in DB
  Future<Widget> _distances() async {
    double distance;
    for(int i=0; i < posts.length; i++){
        double distanceInMeters = await Geolocator().distanceBetween(posts[i].latitude, posts[i].longitude, userLocation.latitude, userLocation.longitude);
        distance = distanceInMeters/1609.344;
        posts[i].distance = distance;
    }
    return Container(width: 0.0, height: 0.0,);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hidden Gems')),
      body: FutureBuilder<void>(
          // waits to get the current location of user before moving on
          future: Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).then((location) {
            userLocation = location;
            return location;
          }),
          builder: (context, snapshot){
              if(snapshot.connectionState == ConnectionState.waiting){
                return new Center(child: new CircularProgressIndicator());
              }else if(snapshot.connectionState == ConnectionState.done){
                if(snapshot.hasError){
                  return new Text('${snapshot.error}');
                }else{
                  return _buildPage();
                }
              }},
      ),
      drawer: MyDrawer(),
    );
  }

  /// Stream that Gets all the posts in the DB
  Widget _buildPage(){
    return StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('posts').where("finished", isEqualTo: true).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new CircularProgressIndicator();
              default:
                posts = _getPosts(snapshot);
                return _distanceBuild();
            }
          },
    );
  }

  /// Calculates the distances between current location with each post
  ///
  /// Then Calls the Listing page which builds the UI of the page
  Widget _distanceBuild(){
    return FutureBuilder<void>(
      future: _distances(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return new Center(child: new CircularProgressIndicator());
        }else if(snapshot.connectionState == ConnectionState.done){
          if(snapshot.hasError){
            return new Text('${snapshot.error}');
          }else{
            posts.sort((a,b) => a.distance.round() - b.distance.round());
            return ListingPage(posts: posts);
          }
        }
      },
    );
  }


}