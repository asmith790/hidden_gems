import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navBar.dart';
import 'post.dart';


class listView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hidden Gems')),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Center(child: new CircularProgressIndicator());
            default:
              return new ListView(
                children:
                    snapshot.data.documents.map((DocumentSnapshot document) {
                  return new ListTile(
                    title: new Text(
                      document['name'],
                      style: TextStyle(
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    subtitle: new Row(children: <Widget>[
                      new Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                                text: document['description'],
                                style: TextStyle(
                                  fontSize: 18.0,
                                )),
                            TextSpan(
                                text: '\ndistance here',
                                style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 18.0)),
                            TextSpan(
                                text: '\n${document['tags'].toString()}',
                                style: TextStyle(
                                    fontSize: 18.0,
                                fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ]),
                    isThreeLine: true,
                    leading: Column(
                      children: <Widget>[
                        Image.asset(
                          //Would become a photo
                          'assets/gem.png',
                          width: 70.0,
                          height: 45,
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => new Post()),
                        /*Todo: pass the post Id so I can get post data for the right post*/
                      );
                      //Navigator.pop(context);
                    },
                  );
                }).toList(),
              );
          }
        },
      ),
      drawer: MyDrawer(),
    );
  }
}
