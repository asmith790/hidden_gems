import 'package:flutter/material.dart';
import 'post.dart';
import 'postView.dart';

class ListingPage extends StatefulWidget{
  final List<Post> posts;

  @override
  ListingPage({this.posts});
  State<StatefulWidget> createState() => new ListingPageState(posts);
}

class ListingPageState extends State<ListingPage> {
  List<Post> posts;

  ListingPageState(List<Post> posts){
    this.posts = posts;
  }

  TextEditingController controller = new TextEditingController();
  String filter = "";

//Place posts from Query into here
  Image getPicture(String url) {
    if (url == "") {
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
  initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        filter = controller.text;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(15, 10, 15, 5),
        child: TextField( //Work around
          decoration: new InputDecoration(
            labelText: "Search",
            suffixIcon: Icon(Icons.search),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue)
            ),
          ),
          controller: controller,
        ),
      ),
      Expanded(
        child:

        ListView.builder(
            shrinkWrap: true,
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              return posts[index].name.toLowerCase().contains(filter.toLowerCase()) || posts[index].tags.toLowerCase().contains(filter.toLowerCase()) ? new Container (
                child: ListTile(
                  title: new Text(
                    posts[index].name,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  subtitle: new Row(children: <Widget>[
                    new Text.rich(
                      TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                              text: posts[index].description,
                              style: TextStyle(
                                fontSize: 18.0,
                              )),
                          TextSpan(
                              text: '\ndistance here\n',
                              style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18.0)),
                          TextSpan(
                              text: posts[index].tags.toString(),
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ]),
                  isThreeLine: true,
                  leading: Column(
                    children: <Widget>[
                      getPicture(posts[index].imgUrl),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      new MaterialPageRoute(builder: (context) => new PostView(id: posts[index].id)),
                    );
                  },
                ),
              ): new Container();
            }

        ),
      ),
    ],);
  }
}