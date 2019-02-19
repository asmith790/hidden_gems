import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navBar.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text('Hidden Gems')),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('posts').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Center(
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text('Oops'),
                      ],
                    ),
                  ],
                ),
              );
            default:
              return new Column(
                  children: <Widget>[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: FittedBox(
                          fit:
                              BoxFit.contain, // otherwise the logo will be tiny
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('My Gems'),
                  ],
                ),
                new ListView(
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
                    );
                  }).toList(),
                )
              ]);
          }
        },
      ),
      drawer: MyDrawer(),
    );
  }
}
