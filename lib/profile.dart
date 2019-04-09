import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navBar.dart';
import 'postView.dart';
import 'auth.dart';
import 'authProvider.dart';
import 'profileEdit.dart';


class Profile extends StatefulWidget {
  const Profile({this.onSignedOut});
  final VoidCallback onSignedOut;

  @override
  State<StatefulWidget> createState() => new _Profile();
}

class _Profile extends State<Profile> {
  String _userId;
  String _email = ' ';
  String _username = ' ';
  String _name = ' ';
  String _bio = ' ';
  String _picture = ' ';
  int _rating = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final BaseAuth auth = AuthProvider.of(context).auth;
    //once currentUser() returns a user since it is a Future, then we can do something
    auth.currentUser().then((userId) {
      _userId = userId;
      print('UserId: $userId');
      _getProfileInfo();
    });
  }

  Future<void> _getProfileInfo() async {
    final DocumentReference userInfo = Firestore.instance.collection('users').document(_userId);
    userInfo.get().then((doc){
      if(doc.exists){
        print(doc.data);
        _email = doc.data['email'];
        _username = doc.data['username'];
        _name = doc.data['name'];
        _bio = doc.data['bio'];
        _rating = doc.data['rating'];
        _picture = doc.data['picture'];
      }
    });
  }

  // parameter is context because the inherited widget auth needs it
  Future<void> _signOut(BuildContext context) async{
    try{
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      widget.onSignedOut(); // call voidCallback function
      if(Navigator.canPop(context)) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    }catch(e){
      print(e);
    }
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

  Widget _buildProfileImage() {
    if(_picture.length > 1){
      return Center(
            child: Container(
              width: 140.0,
              height: 140.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
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

  Image _profileImage(){
    return Image.network(
      //Would become a photo
      _picture,
      width: 76.0,
      height: 45,
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

  Widget _buildPage(){
    return Column(
      children: <Widget>[
        // top portion
        Padding(
            padding: EdgeInsets.only(top: 15)
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                //TODO: able to add a profile image
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
        Padding(
            padding: EdgeInsets.only(bottom: 20)
        ),
        _buildBio(context),
        Padding(
            padding: EdgeInsets.only(bottom: 20)
        ),
        Divider(
          height: 2.0,
          color: Colors.grey,
        ),
        // Displaying user Gems
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
                  children: snapshot.data.documents.map((DocumentSnapshot doc){
                    for(int i = 0; i < doc.data['name'].length; i++){
                      print(doc.data['name']);
                      /// details about gems the user has posted
                      return Column(
                        children: <Widget>[
                          ListTile(
                            leading: getPicture(doc.data['picture']),
                            title: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                _titleGems(doc),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    _rateGems(doc),
                                    Padding(
                                      padding: EdgeInsets.only(left: 5)
                                    ),
                                    _thumbs(doc),
                                  ],
                                )
                              ],
                            ),
                            subtitle: _descGems(doc),
                            isThreeLine: true,
                            onTap: () {
                              Navigator.push(
                                context,
                                new MaterialPageRoute(builder: (context) => new PostView(id: doc.documentID)),
                              );
                            },
                          ),
                          Divider(
                            height: 2.0,
                            color: Colors.grey,
                          ),
                        ],
                      );
                    }
                  }).toList(),
                );
            }
          },
        ),
        FlatButton(
          child: Text(
            'Edit Page',
            style: new TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400,
            ),
          ),
          onPressed: (){
            Navigator.push(
              context,
              new MaterialPageRoute(builder: (context) => new ProfileEdit(value: User(
                  userId: _userId,
                  username: _username,
                  name: _name,
                  email: _email,
                  bio: _bio,
                  imageUrl: _picture
              ))),
            );
          },
        ),
      ],
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text('Hidden Gems'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => _signOut(context),
              child: new Text(
                'Logout',
                style: new TextStyle(
                    fontSize: 17.0,
                    color: Colors.white
                ),
              )
            )
          ]
      ),
      body: Center(
        child: FutureBuilder<void>(
          future: Firestore.instance.collection('users').document(_userId).get().then((doc){
                        if(doc.exists){
                          print(doc.data);
                          _email = doc.data['email'];
                          _username = doc.data['username'];
                          _name = doc.data['name'];
                          _bio = doc.data['bio'];
                          _rating = doc.data['rating'];
                        }}),
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return new Center(child: new CircularProgressIndicator());
            }else if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasError){
                return new Text('${snapshot.error}');
              }else{
                return _buildPage();
              }
            }
          }
        )
      ),
      drawer: MyDrawer(),
    );
  }
}
