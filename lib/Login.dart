import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:newsapp/Network/Network_Sensitive.dart';
import 'Landing.dart';
import 'Register.dart';
import 'Global/GlobalData.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  DateTime currentBackPressTime;
  UserCredential userCredential;
  String emailErrorText, passwordErrorText;

  signIn(email, password) async {
    print(email);
    print(password);
    try {
      userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Landing()));
    } on FirebaseAuthException catch (e) {
      print('Error Code:${e.code}');
      if (e.code == 'user-not-found') {
        showSnackBar(context, 'Not Registered');
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Register()));
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        setState(() {
          passwordErrorText = 'Incorrect Password';
        });
        print('Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        print('Wrong password provided for that user.');
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bright = MediaQuery.of(context).platformBrightness;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor:
            bright == Brightness.light ? Colors.black : Colors.white));
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return NetworkSensitive(
      child: WillPopScope(
        onWillPop: onWillPop,
        child: SafeArea(
          child: Scaffold(
            body: Container(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 80,
                    width: 80,
                    margin: EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [startColor, endColor]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'The\n News',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 22),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                    // height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: email,
                      style: myTextStyle(),
                      obscuringCharacter: '*',
                      onChanged: (val) {
                        setState(() {
                          emailErrorText = null;
                        });
                      },
                      decoration: myInputDecoration('E mail', emailErrorText),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                    // height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: TextField(
                      controller: password,
                      style: myTextStyle(),
                      obscureText: true,
                      obscuringCharacter: '*',
                      onChanged: (val) {
                        setState(() {
                          passwordErrorText = null;
                        });
                      },
                      decoration:
                          myInputDecoration('Password', passwordErrorText),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (email.text.trim() == '') {
                        setState(() {
                          emailErrorText = 'Enter E mail';
                        });
                      } else if (!RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(email.text)) {
                        setState(() {
                          emailErrorText = 'Enter valid E-mail';
                        });
                      } else if (password.text.trim() == '') {
                        setState(() {
                          passwordErrorText = 'Enter Password';
                        });
                      } else {
                        signIn(email.text, password.text);
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [startColor, endColor],
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Spacer(),
                  Container(
                    margin: EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Not Registered? ',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register()));
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: startColor),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime) > Duration(seconds: 2)) {
      currentBackPressTime = now;

      showSnackBar(context, 'Press Again to exit');
      return Future.value(false);
    } else {
      SystemNavigator.pop();
      return Future.value(true);
    }
  }
}
