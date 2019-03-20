import 'package:flutter/material.dart';
import 'navBar.dart';
import 'auth.dart';


class HomePage extends StatelessWidget{
  HomePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  void _signOut() async{
    try{
      await auth.signOut();
      onSignedOut(); // call voidCallback function
    }catch(e){
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Home'),
        actions: <Widget>[
          new FlatButton(
            child:new Text(
              'Logout',
              style: new TextStyle(
                fontSize: 17.0,
                color: Colors.white
              )
            ),
            onPressed: _signOut,
          )
        ]
      ),
      body: new Text(
        'This is hidden gems'
      ),
      drawer: new MyDrawer(), // this is the menu bar
    );
  }
}