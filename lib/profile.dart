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

  Widget _buildFullName() {
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

  Widget _buildBio(BuildContext context) {
    TextStyle bioTextStyle = TextStyle(
      fontFamily: 'Spectral',
      fontWeight: FontWeight.w400,//try changing weight to w500 if not thin
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

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width / 1.6,
      height: 2.0,
      color: Colors.black54,
      margin: EdgeInsets.only(top: 4.0),
    );
  }

  Widget _buildProfileImage() {
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/gem.png'),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.circular(80.0),
          border: Border.all(
            color: Colors.white,
            width: 10.0,
          ),
        ),
      ),
    );
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
        child: Column(
          children: <Widget>[
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
                        _buildFullName(),
                        Text(_username)
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
//                Text('My Gems'),
//                StreamBuilder<QuerySnapshot>(
//                stream: Firestore.instance.collection('posts').where("userid", isEqualTo: _userId).snapshots(),
//                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//
              ]
            ),
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
