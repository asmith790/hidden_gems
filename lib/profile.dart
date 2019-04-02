import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'navBar.dart';
import 'postView.dart';
import 'auth.dart';
import 'authProvider.dart';


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
                      // TODO: display the users info here
                      Text(_name),
                      Text(_username),
                      Text(_email),
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
      body: new ListView.builder(
          itemBuilder: null
      ),
      drawer: MyDrawer(),
    );
  }
}
