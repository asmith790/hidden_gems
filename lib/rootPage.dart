import 'package:flutter/material.dart';
import 'auth.dart';
import 'loginPage.dart';
import 'homePage.dart';

class RootPage extends StatefulWidget{
  RootPage({this.auth});
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus{
  notSignedIn,
  signedIn
}

class _RootPageState extends State<RootPage>{
  AuthStatus _authStatus = AuthStatus.notSignedIn;

  initState() {
    super.initState();
    //once currentUser() returns a user since it is a Future, then we can do something
    widget.auth.currentUser().then((userId){
      setState(() {
        // if userId = null then we set the auth status to not signed in
        _authStatus = userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _signedIn(){
    setState((){
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut(){
    setState((){
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notSignedIn:
        return new Login(
            auth: widget.auth,
            onSignedIn: _signedIn,
        );
      case AuthStatus.signedIn:
        return new HomePage(
          auth: widget.auth,
          onSignedOut: _signedOut
        );
    }
  }
}