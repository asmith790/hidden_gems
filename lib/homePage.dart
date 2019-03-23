import 'package:flutter/material.dart';
import 'authProvider.dart';
import 'navBar.dart';
import 'auth.dart';

class HomePage extends StatelessWidget{
  const HomePage({this.onSignedOut});
  final VoidCallback onSignedOut;

  // parameter is context because the inherited widget auth needs it
  Future<void> _signOut(BuildContext context) async{
    try{
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      onSignedOut(); // call voidCallback function
      if(Navigator.canPop(context)) {
//        Navigator.popUntil(context, ModalRoute.withName(Navigator.defaultRouteName));
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
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
              onPressed: () => _signOut(context),
              child: new Text(
                'Logout',
                style: new TextStyle(
                  fontSize: 17.0,
                  color: Colors.white
                ),
              )
          )
        ],
      ),
      body: Container(
        child: Center(
            child: Text(
                'Welcome',
                style: TextStyle(fontSize: 32.0)
            )
        ),
      ),
      drawer: MyDrawer(),
    );
  }
}