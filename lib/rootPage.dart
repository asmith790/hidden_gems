import 'package:flutter/material.dart';
import 'loginPage.dart';
import 'authProvider.dart';
import 'auth.dart';
import 'profile.dart';


class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => new _RootPageState();
}

enum AuthStatus{
  notDetermined,
  notSignedIn,
  signedIn
}

class _RootPageState extends State<RootPage> {
  // current state of the user
  AuthStatus _authStatus = AuthStatus.notDetermined;

  String _email;

  // use this instead of init state since we are using an inherited widget for Auth
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final BaseAuth auth = AuthProvider.of(context).auth;
    //once currentUser() returns a user since it is a Future, then we can do something
    auth.currentUser().then((userId) {
      setState(() {
        // if userId = null then we set the auth status to not signed in
        _authStatus =
        userId == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
      // get email from userI
    });
  }

  void _signedIn() {
    setState(() {
      _authStatus = AuthStatus.signedIn;
    });
  }

  void _signedOut() {
    setState(() {
      _authStatus = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_authStatus) {
      case AuthStatus.notDetermined:
        return _buildWaitingScreen();
      case AuthStatus.notSignedIn:
        return new Login(
            onSignedIn: _signedIn
        );
      case AuthStatus.signedIn:
        return new Profile(
            onSignedOut: _signedOut
        );
    }
    return null;
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }
}