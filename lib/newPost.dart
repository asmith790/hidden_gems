import 'package:flutter/material.dart';
import 'navBar.dart';

class CustomForm extends StatefulWidget {
  @override
  NewPost createState() => NewPost();
}
class NewPost extends State<CustomForm> {
  @override
  final myController = TextEditingController();
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(title: Text('Hidden Gems')),
      body: ListView(
        children: <Widget>[
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/map.png', width: MediaQuery.of(context).size.width, height: 240,
                ),  //To be replaced with google map/photo of gem
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  decoration: const InputDecoration(helperText: "Name"),
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  decoration: const InputDecoration(helperText: "Description"),
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  decoration: const InputDecoration(helperText: "Tags"),
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  decoration: const InputDecoration(helperText: "Author"),
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  decoration: const InputDecoration(helperText: "Rating"),
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Flexible(
                child: new TextField(
                  decoration: const InputDecoration(helperText: "Post Count"),
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new RaisedButton(
                padding: const EdgeInsets.all(8.0),
                textColor: Colors.white,
                color: Colors.blue,
                //onPressed: addNumbers, call on function when pressed
                child: new Text("Add a Gem"),
              ),
            ],
          )
        ],
      ),
      drawer: MyDrawer(),
    );
  }
}