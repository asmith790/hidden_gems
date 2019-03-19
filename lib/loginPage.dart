import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Login extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _Login();

}

enum FormType{
  login,
  register
}

class _Login extends State<Login>{
  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login; // initially at the login form

  bool validateAndSave(){
    final form = formKey.currentState; // gets the form state
    if(form.validate()){
      form.save(); // save the state of the form
      print('Form is valid'); // print statements for debugging
//      print('Email: $_email, Password: $_password');
      return true;
    }
    return false;
  }

  //asynchronous function
  void validateAndSubmit() async{
    if(validateAndSave()){
      try{
        if(_formType == FormType.login){
          // Try's to sign in with Firebase, if fails, returns an error, else returns a user
          FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
          print('SignedIn: ${user.uid}');

        }else{
          FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
          print('Registered User: ${user.uid}');
        }
      }catch(e){
        print('Error: $e');
      }
    }
  }

  // move from login page to register page
  void moveToRegister(){
    formKey.currentState.reset(); // reset the values that were saved previously in form fields
    // new UI -> new state
    setState(() {
      _formType = FormType.register;
    });
  }
  // move from register page to login page
  void moveToLogin(){
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          title: Text('Login Page'),
        ),
        body: new Container(
          padding: EdgeInsets.all(16.0),
          child: new Form(
            key: formKey,
            child: new Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildInputs() + buildSubmitButtons(),
            ),
          )
        )
      );
  }


  List<Widget> buildInputs(){
    // email and password fields - in both forms
    return [
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Email'),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons(){
    if(_formType == FormType.login){
      return [
        new RaisedButton(
          child: new Text(
            'Login',
            style: new TextStyle(
              fontSize: 20.0,
            ),
          ),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text(
            'Create New Account',
            style: new TextStyle(
              fontSize: 20.0,
            ),
          ),
          onPressed: moveToRegister,
        )
      ];
    }else{
      return [
        new RaisedButton(
          child: new Text(
            'Create New Account',
            style: new TextStyle(
              fontSize: 20.0,
            ),
          ),
          onPressed: validateAndSubmit,
        ),
        new FlatButton(
          child: new Text(
            'Have an Account? Login',
            style: new TextStyle(
              fontSize: 20.0,
            ),
          ),
          onPressed: moveToLogin,
        )
      ];
    }
  }

}
