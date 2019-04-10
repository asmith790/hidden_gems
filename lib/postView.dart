import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'profileWorld.dart';
import 'post.dart';
import 'voteTracker.dart';

class PostView extends StatelessWidget {
  final String id;
  PostView({this.id});
  List<Post> posts;

  List <String> _tags = new List();

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
                  posts = snapshot.data.documents.map((document) => new Post(
                      description: document["description"],
                      name: document["name"],
                      tags: document["tags"].toString(),    //Update this to the tag thing Sami is using
                      rating: document["rating"],
                      userid: document["userid"],
                      imgUrl: document["picture"],
                  )).toList();
//                  snapshot.data.documents.map((DocumentSnapshot doc){
//                    _tags = doc.data['tags'];
//                    print(_tags);
//                  }).toString();
                  return new Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      IntrinsicHeight(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            _getImage(context),
                          ],
                        ),
                      ),
                      _divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          //TODO: Add this
                          Text('Distance'),

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            posts[0].name,
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.5,
                                color: Colors.blue
                            ),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                              posts[0].description,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.8,
                                color: Colors.black54,
                              ),
                          ),
                        ],
                      ),
                      _simplePadding(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //TODO: displaying of tags nicer
                        children: <Widget>[
                          Text(posts[0].tags),
                        ],
                      ),
                      _simplePadding(),
                      _simplePadding(),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          InkWell(
                            child: Text(
                              posts[0].userid,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.blue,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(builder: (context) => ProfileWorld(username: posts[0].userid)),
                              );
                            },
                          ),
                          _divider(),
                          VoteTracker(count: posts[0].rating, postId: id,),
                        ],
                      )
                    ],
                  );
              }
            },
          ),
        ],
      ),
      ),
    );
  }


  //------------- Widgets -----------
  Padding _simplePadding(){
    return Padding(
      padding: EdgeInsets.only(top: 10.0),
    );
  }

  Divider _divider(){
    return Divider(
      height: 2.0,
      color: Colors.grey,
    );
  }

  Widget _getImage(BuildContext context){
    if(posts[0].imgUrl == ""){
      return Image.asset(
        //Would become a photo
        'assets/gem.png',
        width: MediaQuery.of(context).size.width,
        height: 200,
      );
    }
    return Image.network(
      posts[0].imgUrl,
      width: MediaQuery.of(context).size.width,
      height: 200,
    );
  }
}