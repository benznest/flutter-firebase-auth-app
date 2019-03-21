import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/forgot_password_page.dart';
import 'package:flutter_firebase_app/home_page.dart';
import 'package:flutter_firebase_app/phone_verify_page.dart';
import 'package:flutter_firebase_app/register_page.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key key}) : super(key: key);

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    checkAuth(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title: Text("My Firebase App", style: TextStyle(color: Colors.white)),
        ),
        body: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.green[200], Colors.green[300]])),
            child: Center(
                child: ListView(shrinkWrap: true, children: <Widget>[
              Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                          colors: [Colors.yellow[100], Colors.green[100]])),
                  margin: EdgeInsets.all(32),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      buildTextFieldEmail(),
                      buildTextFieldPassword(),
                      buildButtonSignIn(context),
                      buildOtherLine("Don’t have an account?"),
//                      buildButtonFacebook(context),
//                      buildButtonGoogle(context),
//                      buildButtonPhone(context),
                      buildButtonRegister(context),
                      buildOtherLine("Other"),
                      buildButtonForgotPassword(context),
                    ],
                  )),
            ]))));
  }

  Widget buildButtonSignIn(BuildContext context) {
    return InkWell(
      child: Container(
          constraints: BoxConstraints.expand(height: 50),
          child: Text("Sign in",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.white)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.green[200]),
          margin: EdgeInsets.only(top: 16),
          padding: EdgeInsets.all(12)),
      onTap: () {
        signIn(context);
      },
    );
  }

  Widget buildButtonRegister(BuildContext context) {
    return InkWell(
        child: Container(
            constraints: BoxConstraints.expand(height: 50),
            child: Text("Sign up",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.orange[200]),
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(12)),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => MySignUpPage()));
        });
  }

  Widget buildButtonFacebook(BuildContext context) {
    return InkWell(
        child: Container(
            constraints: BoxConstraints.expand(height: 50),
            child: Text("Login with Facebook ",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.blue[400]),
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(12)),
        onTap: () => loginWithFacebook(context));
  }

  Widget buildButtonGoogle(BuildContext context) {
    return InkWell(
        child: Container(
            constraints: BoxConstraints.expand(height: 50),
            child: Text("Login with Google ",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.blue[600])),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16), color: Colors.white),
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(12)),
        onTap: () => loginWithGoogle(context));
  }

  Widget buildButtonPhone(BuildContext context) {
    return InkWell(
        child: Container(
            constraints: BoxConstraints.expand(height: 50),
            child: Text("Login with phone number",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.pink[200]),
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(12)),
        onTap: () => navigateToPhoneVerifyPage(context));
  }

  Container buildTextFieldEmail() {
    return Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
        child: TextField(
            controller: emailController,
            decoration: InputDecoration.collapsed(hintText: "Email"),
            style: TextStyle(fontSize: 18)));
  }

  Container buildTextFieldPassword() {
    return Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
            color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
        child: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration.collapsed(hintText: "Password"),
            style: TextStyle(fontSize: 18)));
  }

  Widget buildOtherLine(String str) {
    return Container(
        margin: EdgeInsets.only(top: 14),
        child: Row(children: <Widget>[
          Expanded(child: Divider(color: Colors.green[800])),
          Padding(
              padding: EdgeInsets.all(6),
              child: Text(str,
                  style: TextStyle(color: Colors.black87))),
          Expanded(child: Divider(color: Colors.green[800])),
        ]));
  }

  signIn(BuildContext context) {
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .then((user) {
      print("signed in ${user.email}");
      checkAuth(context);
    }).catchError((error) {
      print(error.message);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(error.message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    });
  }

  Future checkAuth(BuildContext context) async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      print("Already singed-in with");
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage(user)));
    }
  }

  Future loginWithFacebook(BuildContext context) async {
    FacebookLogin facebookLogin = FacebookLogin();
    FacebookLoginResult result = await facebookLogin
        .logInWithReadPermissions(['email', "public_profile"]);

    String token = result.accessToken.token;
    print("Access token = $token");
    await _auth.signInWithCredential(
        FacebookAuthProvider.getCredential(accessToken: token));
    checkAuth(context);
  }

  Future loginWithGoogle(BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    bool isSigned = await _googleSignIn.isSignedIn();
    if (isSigned) {
      await _googleSignIn.signOut();
    }

//    GoogleSignInAccount user = await
    _googleSignIn.signIn().then((user) async {
      GoogleSignInAuthentication userAuth = await user.authentication;
      await _auth.signInWithCredential(GoogleAuthProvider.getCredential(
          idToken: userAuth.idToken, accessToken: userAuth.accessToken));
      checkAuth(context);
    }).catchError((error) {
      print("ERROR " + error.message);
    });
  }

  navigateToPhoneVerifyPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyPhoneVerifyPage()));
  }


  buildButtonForgotPassword(BuildContext context) {
    return InkWell(
        child: Container(
            constraints: BoxConstraints.expand(height: 50),
            child: Text("Forgot password",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.red[300]),
            margin: EdgeInsets.only(top: 12),
            padding: EdgeInsets.all(12)),
        onTap: () => navigateToResetPasswordPage(context));
  }

  navigateToResetPasswordPage(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyResetPasswordPage()));
  }
}
