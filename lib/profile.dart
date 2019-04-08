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
    return Center(
      child: Container(
        width: 140.0,
        height: 140.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/gem.png'),
            fit: BoxFit.scaleDown,
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
            // top portion
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
                        _buildRating(_rating)
                        //TODO: add rating here
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
                                return ListTile(
                                  title: Text(
                                    doc.data['name'],
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                );
                              }
                          }).toList(),
                      );
                  }
                  },
            ),
          ],
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}
