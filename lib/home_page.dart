import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/login_page.dart';

class MyHomePage extends StatefulWidget {
  final FirebaseUser user;

  MyHomePage(this.user, {Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Firebase App", style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.exit_to_app),
                color: Colors.white,
                onPressed: () {
                  signOut(context);
                })
          ],
        ),
        body: Container(
            child: Center(
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Text("Hello", style: TextStyle(fontSize: 26)),
          Text(widget.user.email ?? widget.user.phoneNumber,
              style: TextStyle(fontSize: 16)),
        ]))));
  }

  void signOut(BuildContext context) {
    _auth.signOut();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyLoginPage()),
        ModalRoute.withName('/'));
  }
}
