import 'package:flutter/material.dart';
import 'authProvider.dart';
import 'auth.dart';

class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Email can\'t be empty' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Password can\'t be empty' : null;
  }
}

class Login extends StatefulWidget {
  Login({this.onSignedIn});
  // a voidCallback takes no parameters and returns no parameters
  final VoidCallback onSignedIn;

  @override
  State<StatefulWidget> createState() => new _Login();
}

enum FormType{
  login,
  register
}

class _Login extends State<Login>{
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  FormType _formType = FormType.login; // initially at the login form

  bool validateAndSave(){
    final form = formKey.currentState; // gets the form state
    if(form.validate()){
      form.save(); // save the state of the form
      return true;
    }
    return false;
  }

  //asynchronous function
  Future<void> validateAndSubmit() async{
    if(validateAndSave()){
      try{
        final BaseAuth auth = AuthProvider.of(context).auth;
        if(_formType == FormType.login){
          final String userId = await auth.signInWithEmailAndPassword(_email, _password);
          print('SignedIn: $userId');

        }else{
          final String userId = await auth.createUserWithEmailAndPassword(_email, _password);
          print('Registered User: $userId');
        }
        // after we either sign in or create an account, we want to be signed in
        widget.onSignedIn(); // ensure the rootPage receives message we are signedIn
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
          automaticallyImplyLeading: false,
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
        key: Key('email'),
        decoration: new InputDecoration(labelText: 'Email'),
        validator: EmailFieldValidator.validate,
        onSaved: (String value) => _email = value,
      ),
      new TextFormField(
        key: Key('password'),
        decoration: new InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: PasswordFieldValidator.validate,
        onSaved: (String value) => _password = value,
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
