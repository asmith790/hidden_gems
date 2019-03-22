import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navBar.dart';
import 'postView.dart';

class Profile extends StatelessWidget {
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

  Center userInfo(){
    return Center(
      child: Column(
        children: <Widget>[
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: FittedBox(
                    fit: BoxFit
                        .contain, // otherwise the logo will be tiny
                    child: const FlutterLogo(),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Name Test'),
                      Text('Username'),
                      Text('Rating'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20)
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('My Gems'),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Hidden Gems')),
      body: Column(
    children: <Widget>[
      StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('posts').where("userid", isEqualTo: "mel123").snapshots(), //Change username to logged in user
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Container(child: userInfo());
            default:
              return new Column(
                  children: <Widget>[
                    userInfo(),
                    ListView(
                shrinkWrap: true,
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
              )]);
          }
        },
      ),
      ]),
      drawer: MyDrawer(),
    );
  }
}
