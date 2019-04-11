import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'navBar.dart';
import 'postView.dart';

class ProfileWorld extends StatefulWidget {
  final String username;
  ProfileWorld({Key key, this.username}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new _ProfileWorld();
}

class _ProfileWorld extends State<ProfileWorld> {
  String _email = ' ';
  String _username = ' ';
  String _name = ' ';
  String _bio = ' ';
  String _picture = ' ';
  int _rating = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _username = widget.username;
    print('Username: $_username');
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text('Hidden Gems'),
      ),
      body: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance.collection('users').where("username", isEqualTo: _username).snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return new Text('${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Center(child: new CircularProgressIndicator());
                  default:
                    return _setUp(snapshot);
                }
              },
          )
      ),
    );
  }

  Widget _setUp(AsyncSnapshot<QuerySnapshot> snapshot){
    snapshot.data.documents.map((DocumentSnapshot doc) {
      _email = doc.data['email'];
      _username = doc.data['username'];
      _name = doc.data['name'];
      _bio = doc.data['bio'];
      _picture = doc.data['picture'];
      _rating = doc.data['rating'];
      print('Email: ' + _name);

    }).toString();
    return _buildPage(context);
  }

  /// Widget that creates the whole page after fetches information
  Widget _buildPage(BuildContext context){
    return Scrollbar( child: Column(
      children: <Widget>[
        // top portion
        _simplePadding(),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: _buildProfileImage(),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildName(),
                    _buildUsername(),
                    Padding(
                        padding: EdgeInsets.only(bottom: 10)
                    ),
                    //TODO: add rating here
                    _buildRating(_rating),
                  ],
                ),
              ),
            ],
          ),
        ),
        _simplePadding(),
        _buildBio(context),
        _simplePadding(),
        _divider(),
        /// Displays user Gems
        StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('posts').where("userid", isEqualTo: _username).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return new Center(child: new CircularProgressIndicator());
              default:
                return ListView(
                  shrinkWrap: true,
                  children: ListTile.divideTiles(
                    context: context,
                    tiles: snapshot.data.documents.map((DocumentSnapshot doc){
                      for(int i = 0; i < doc.data['name'].length; i++){
                        String curr = doc.data['name'];
                        print(curr);
                        /// details about gems the user has posted
                        return ListTile(
                          leading: getPicture(doc.data['picture']),
                          title: _titleGems(doc),
                          subtitle: _descGems(doc),
                          isThreeLine: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              new MaterialPageRoute(builder: (context) => new PostView(id: doc.documentID, username: _username)),
                            );
                          },
                        );
                      }
                    }),
                  ).toList(),
                );
            }
          },
        ),
        _simplePadding(),
        Padding(
            padding: EdgeInsets.only(bottom: 25)
        )
      ],
    )
    );
  }

  // ---- Other Widgets ----

  Padding _simplePadding(){
    return Padding(
        padding: EdgeInsets.only(bottom: 15)
    );
  }

  Divider _divider(){
    return Divider(
      height: 2.0,
      color: Colors.grey,
    );
  }
  Widget _buildName() {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w600,
    );
    return Text(
      _name,
      style: _nameTextStyle,
    );
  }

  Widget _buildUsername(){
    TextStyle _userNameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black38,
      fontSize: 18.0,
      fontWeight: FontWeight.w400,
    );

    return Text(
      _username,
      style: _userNameTextStyle,
    );
  }

  Widget _buildProfileImage() {
    if(_picture.length > 1){
      return Center(
        child: Container(
          width: 140.0,
          height: 140.0,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fitHeight,
              image: NetworkImage(_picture),
            ),
            borderRadius: BorderRadius.circular(80.0),
            border: Border.all(
              color: Colors.white,
              width: 10.0,
            ),
          ),
        ),
      );
    }else{
      // if user doesn't have a profile picture in Database
      return Center(
        child: Container(
          width: 140.0,
          height: 140.0,
          child: Icon(
            Icons.person,
            size: 60.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(80.0),
            border: Border.all(
              color: Colors.white,
              width: 10.0,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400,
      fontStyle: FontStyle.italic,
      color: Color(0xFF799497),
      fontSize: 16.0,
    );

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.all(8.0),
      child: Text(
        _bio,
        textAlign: TextAlign.center,
        style: bioTextStyle,
      ),
    );
  }


  Widget _buildRating(int rating){
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          color: Colors.amber,
        );
      }),
    );
  }

  /// getting picture for gems
  Image getPicture(String url){
    if(url == ""){
      return Image.asset(
        //Would become a photo
        'assets/gem.png',
        width: 76.0,
        height: 45,
      );
    }
    return Image.network(
      //Would become a photo
      url,
      width: 76.0,
    );
  }
  Icon _thumbs(DocumentSnapshot doc){
    int rating = doc.data['rating'];
    if(rating < 0){
      return Icon(
        Icons.thumb_down,
        color: Colors.blue,
        size: 20.0,
      );
    }else{
      return Icon(
        Icons.thumb_up,
        color: Colors.blue,
        size: 20.0,
      );
    }
  }
  Text _titleGems(DocumentSnapshot doc){
    return Text(
      doc.data['name'],
      style: TextStyle(
        fontSize: 22.0,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
    );
  }

  Text _descGems(DocumentSnapshot doc){
    return Text(
      doc.data['description'],
      style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: Colors.black38
      ),
    );
  }

  Text _rateGems(DocumentSnapshot doc){
    return Text(
      doc.data['rating'].toString(),
      style: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: Colors.black38
      ),
    );
  }
}