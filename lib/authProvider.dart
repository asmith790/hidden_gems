import 'package:flutter/material.dart';
import 'auth.dart';

class AuthProvider extends InheritedWidget{
  AuthProvider({Key key, Widget child, this.auth}) : super(key: key, child: child);
  final BaseAuth auth;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  /// This is a static method that will help find the widget that matches AuthProvider
  static AuthProvider of(BuildContext context){
    return(context.inheritFromWidgetOfExactType(AuthProvider) as AuthProvider);
  }

}
