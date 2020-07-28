import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterbarberagent/dash_board.dart';
import 'package:flutterbarberagent/forget_password.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

class LoginAndSignupPage extends StatefulWidget {
  const LoginAndSignupPage();

  @override
  _LoginAndSignupPage createState() => _LoginAndSignupPage();
}

class _LoginAndSignupPage extends State<LoginAndSignupPage>
    with TickerProviderStateMixin {
  bool pass = true;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  String email, password;

  bool _progress = false;

  final _loginFormKey = GlobalKey<FormState>();

  void _showSnackBar(message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      backgroundColor: Colors.black,
      content: Text(message),
      duration: Duration(seconds: 5),
    ));
  }

  Widget loginPage(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: double.infinity,
          color: Color(0xFF6427FF)
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: MediaQuery.of(context).padding.top + AppBar().preferredSize.height),
                Container(
                  child: CircleAvatar(
                    child: Text("Logo",),
                    radius: 40,
                    backgroundColor: Colors.black,
                  ),
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 50.0,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Form(
                    key: _loginFormKey,
                    child: ListView(
                      children: <Widget>[

                        Theme(
                          data: ThemeData(primaryColor: Colors.black),
                          child: TextFormField(
                            onSaved: (value) => email = value,
                            validator: (value) {
                              if (value.isEmpty || value == null)
                                return "Invalid Email";
                            },
                            decoration: InputDecoration(
                              hintText: "Email",
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Theme(
                          data: ThemeData(primaryColor: Colors.black),
                          child: TextFormField(
                            obscureText: true,
                            validator: (value) {
                              if (value.isEmpty || value == null)
                                return "Invalid password";
                            },
                            onSaved: (value) => password = value,
                            decoration: InputDecoration(
                              hintText: "Password",
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        GestureDetector(
                          child: Text(
                            "Forgot password?",
                            style: TextStyle(color: Colors.red,),
                          ),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage(),
                            ));
                          }),
                        SizedBox(height: 20),
                        _progress
                          ? Container(
                            child: Center(child: CircularProgressIndicator()),
                          )
                          : ButtonTheme(
                              child: RaisedButton(
                                color: Colors.black,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                onPressed: () async {
                                  if (!_loginFormKey.currentState.validate()) {
                                    return;
                                  }
                                  setState(() {
                                    _progress = true;
                                  });
                                  _loginFormKey.currentState.save();
                                  login(email: email.trim(), password: password)
                                      .then((res) {
                                    if (res['success']) {
                                      setState(() {
                                        _progress = true;
                                      });
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                          builder: (context) => DashBoard(),
                                        ),
                                        (Route<dynamic> route) => false);
                                    }
                                    else {
                                      setState(() {
                                        _progress = false;
                                      });
                                      _showSnackBar(res['message']);
                                    }
                                  });
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(
                                      Icons.email,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 30),
                                    Text(
                                      "Sign In with Email",
                                      style: TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                  ],
                                ),
                              ),
                              minWidth: MediaQuery.of(context).size.width,
                          ),
                        SizedBox(height: 20),
                      ],
                    )),
      ),
              ],
            ),
          ),
        ),
    ]);
  }

  Future login({email, password}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    bool check = await checkInternet();
    String message = 'Something went wrong';
    bool successful = false;
    if (check) {
      await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) async {
        if (user.user != null) {
          print('success');
          QuerySnapshot querySnapshot = await Firestore.instance
              .collection("users_agent")
              .where('email', isEqualTo: email)
              .getDocuments();
          if (querySnapshot != null && querySnapshot.documents.length > 0) {
            successful = true;
            prefs.setString('email', email);
          } else {
            print('failed');
            message = 'Kindly activate your email';
          }
        } else {
          print('failed');
          message = 'Kindly activate your email';
        }
      }).catchError((onError) {
        print("error $onError");
        message = 'Invalid email or password';
      });
    } else {
      message = 'Kindly check your internet connection!';
    }
    return {'success': successful, 'message': message};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent[700],
      key: _scaffoldKey,
      body: loginPage(context),
    );
  }

  Future<bool> checkInternet() async {
    try {
      final result1 = await http
          .read('https://jsonplaceholder.typicode.com/todos/1')
          .timeout(const Duration(seconds: 5));

      return true;
    } catch (e) {
      return false;
    }
  }
}
