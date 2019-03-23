import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navBar.dart';
import 'postView.dart';
import 'auth.dart';
import 'rootPage.dart';

class ListingPage extends StatelessWidget {

  Image getPicture(String url){
    if(url == ""){
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hidden Gems')),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('posts').where("finished", isEqualTo: true).snapshots(),
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
                      getPicture(document['picture']),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(builder: (context) => new PostView(id: document.documentID)),
                      );
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
