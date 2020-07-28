import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ForgotPasswordPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String email;
  bool loader = false;
  @override
  void dispose() {
    super.dispose();
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: Colors.black,
      duration: Duration(seconds: 2),
    ));
  }

  @override
  void initState() {
    super.initState();
  }

  sendEmail() {
    print(email);
    final FirebaseAuth _auth = FirebaseAuth.instance;
    if (email == null || email.isEmpty) {

      showInSnackBar("Kindly enter valid email");
    } else {
      setState(() {
        loader = true;
      });
      _auth.sendPasswordResetEmail(email: email).then((val) {
        setState(() {
          loader = false;
        });
        showInSnackBar("Link has been sent to your email");
      }).catchError((e) {
        setState(() {
          loader = false;
        });
        print(e);
        showInSnackBar(e.toString().substring(
            e.toString().indexOf(',') + 2, e.toString().lastIndexOf(',')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("CHANGE PASSWORD"),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(top: 15, left: 15, right: 15),
        child: ListView(
          children: <Widget>[
            Text(
              "Kindly enter your email address. A link will be sent to your email.",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(
              height: 10,
            ),
            Theme(
              data: ThemeData(primaryColor: Colors.black),
              child: TextField(
                onChanged: (val) => email = val,
                decoration: InputDecoration(
                  hintText: "Your email",
                ),
              ),
            ),
            SizedBox(
              height: 50,
            ),
            loader
                ? Container(
                    width: MediaQuery.of(context).size.width * .5,
                    padding: EdgeInsets.all(10),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : RaisedButton(
                    color: Colors.black,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    onPressed: () => sendEmail(),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          "CHANGE PASSWORD",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
