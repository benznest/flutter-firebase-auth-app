import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/home_page.dart';

class MyPhoneVerifyPage extends StatefulWidget {
  MyPhoneVerifyPage({Key key}) : super(key: key);

  @override
  _MyPhoneVerifyPageState createState() => _MyPhoneVerifyPageState();
}

class _MyPhoneVerifyPageState extends State<MyPhoneVerifyPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController phoneController = TextEditingController();
  TextEditingController smsController = TextEditingController();

  String _verificationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          title:
              Text("Phone verification", style: TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
        ),
        body: Container(
            color: Colors.green[50],
            child: Center(
              child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                          colors: [Colors.yellow[100], Colors.green[100]])),
                  margin: EdgeInsets.all(32),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(children: <Widget>[
                        Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.green[100]),
                            child: Text("+66",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.black54))),
                        Expanded(child: buildTextFieldPhoneNumber()),
                        buildButtonSendSms()
                      ]),
                      buildTextFieldSmsVerification(),
                      buildButtonVerify()
                    ],
                  )),
            )));
  }

  Widget buildButtonVerify() {
    return InkWell(
        child: Container(
            constraints: BoxConstraints.expand(height: 50),
            child: Text("Sign in with Phone",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.green[200]),
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.all(12)),
        onTap: () => verifyPhone());
  }

  Widget buildButtonSendSms() {
    return InkWell(
        child: Container(
            height: 50,
            width: 100,
            child: Text("Send",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.white)),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.orange[300]),
            padding: EdgeInsets.all(12),
            margin: EdgeInsets.only(left: 8)),
        onTap: () => requestVerifyCode(context));
  }

  Container buildTextFieldPhoneNumber() {
    return Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(left: 8),
        constraints: BoxConstraints.expand(height: 50),
        decoration: BoxDecoration(
            color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
        child: TextField(
            controller: phoneController,
            decoration: InputDecoration.collapsed(hintText: "xx-xxx-xxxx"),
            keyboardType: TextInputType.phone,
            style: TextStyle(fontSize: 18)));
  }

  Container buildTextFieldSmsVerification() {
    return Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.only(top: 12),
        decoration: BoxDecoration(
            color: Colors.yellow[50], borderRadius: BorderRadius.circular(16)),
        child: TextField(
            controller: smsController,
            keyboardType: TextInputType.numberWithOptions(),
            maxLength: 6,
            decoration: InputDecoration.collapsed(hintText: "SMS verify"),
            style: TextStyle(fontSize: 18)));
  }

  requestVerifyCode(BuildContext context) {
    _auth.verifyPhoneNumber(
        phoneNumber: "+66" + phoneController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: (user) {

        },
        verificationFailed: (error) {
          print(
              'Phone number verification failed. Code: ${error.code}. Message: ${error.message}');
        },
        codeSent: (verificationId, [forceResendingToken]) {
          setState(() {
            _verificationId = verificationId;
          });
          print(verificationId);
        },
        codeAutoRetrievalTimeout: (verificationId) {
          //
        });
  }

  verifyPhone() async {
    FirebaseUser user = await _auth.signInWithCredential(PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: smsController.text));
    navigateToHomepage(context , user);
  }

  void navigateToHomepage(BuildContext context, FirebaseUser user) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyHomePage(user)),
        ModalRoute.withName('/'));
  }
}
