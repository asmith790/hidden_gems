import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navBar.dart';
import 'post.dart';

class ListingPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new ListingPageState();
}

class ListingPageState extends State<ListingPage> {
  List<Post> posts = new List<Post>();
  TextEditingController controller = new TextEditingController();
  String filter;

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
    )).toList();
    return queryPosts;
  }

  Image getPicture(String url) {
    if (url == "") {
      return Image.asset(
        //Would become a photo
        'assets/gem.png',
        width: 70.0,
        height: 45,
      );
    }
    return Image.network(
      //Would become a photo
      url,
      width: 76.0,
    );
  }

  @override
//  initState() {
//    super.initState();
//    controller.addListener(() {
//      setState(() {
//        filter = controller.text;
//      });
//    });
//    super.initState();
//  }

    @override
    void dispose() {
      controller.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: Text('Hidden Gems')),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('posts').where(
              "finished", isEqualTo: true).snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new TextField( //Work around
                  onSubmitted: (text) {
                    setState(() {
                      filter = text;
                    });
                  },
                  decoration: new InputDecoration(
                      labelText: "Search"
                  ),
                  controller: controller,
                );
              default:
                posts = getPosts(snapshot);
                return new Column(
                  children: <Widget>[
                    TextField( //Work around
                      onSubmitted: (text) {
                        setState(() {
                          filter = text;
                        });
                },
                      decoration: new InputDecoration(
                          labelText: "Search"
                      ),
                      controller: controller,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: posts.length,
                        itemBuilder: (BuildContext context, int index) {
                          return filter == null || filter == "" ?  new Text(posts[index].name) :
                          posts[index].name.toLowerCase().contains(filter.toLowerCase()) ?  Text(posts[index].name) : new Container();
                        }

                    ),
                  ],);
            }
          },
        ),
        drawer: MyDrawer(),
      );
    }
  }
//
//                children:
//                    snapshot.data.documents.map((DocumentSnapshot document) {
//                  return new ListTile(
//                    title: new Text(
//                      document['name'],
//                      style: TextStyle(
//                        fontSize: 22.0,
//                        fontWeight: FontWeight.bold,
//                        color: Colors.blue,
//                      ),
//                    ),
//                    subtitle: new Row(children: <Widget>[
//                      new Text.rich(
//                        TextSpan(
//                          children: <TextSpan>[
//                            TextSpan(
//                                text: document['description'],
//                                style: TextStyle(
//                                  fontSize: 18.0,
//                                )),
//                            TextSpan(
//                                text: '\ndistance here',
//                                style: TextStyle(
//                                    fontStyle: FontStyle.italic,
//                                    fontSize: 18.0)),
//                            TextSpan(
//                                text: '\n${document['tags'].toString()}',
//                                style: TextStyle(
//                                    fontSize: 18.0,
//                                fontWeight: FontWeight.bold)),
//                          ],
//                        ),
//                      ),
//                    ]),
//                    isThreeLine: true,
//                    leading: Column(
//                      children: <Widget>[
//                      getPicture(document['picture']),
//                      ],
//                    ),
//                    onTap: () {
//                      print('document id: ' + document.documentID);
//                      Navigator.push(
//                        context,
//                        new MaterialPageRoute(builder: (context) => new PostView(id: document.documentID)),
//                      );
//                    },
//                  );
//                }).toList(),