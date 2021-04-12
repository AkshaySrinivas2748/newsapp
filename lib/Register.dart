import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newsapp/Network/Network_Sensitive.dart';
import 'Login.dart';
import 'Global/GlobalData.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController userName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController location = TextEditingController();
  String userErrorText,
      emailErrorText,
      passwordErrorText,
      confirmPasswordErrorText,
      locationErrorText;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  registerAccount(email, password) async {
    print('Registering');
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  validate(email, password) {
    if (userName.text.trim() == '') {
      userErrorText = 'Enter User Name';
    } else if (email.text.trim() == '') {
      emailErrorText = 'Enter email';
    } else if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email.text)) {
      emailErrorText = 'Enter Proper E mail';
    } else if (password.text.trim().length < 8) {
      passwordErrorText = 'Password should have atr least 8 characters';
    } else if (password.text != confirmPassword.text) {
      confirmPasswordErrorText = 'Passwords mismatch';
    } else if (location.text.trim() == '') {
      locationErrorText = 'Please Enter Location';
    } else {
      print('${email.text}, ${password.text}');
      registerAccount(email.text, password.text);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var bright = MediaQuery.of(context).platformBrightness;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor:
            bright == Brightness.light ? Colors.black : Colors.white));

    return SafeArea(
      child: NetworkSensitive(
        child: Scaffold(
          body: Container(
            alignment: Alignment.center,
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
                Expanded(
                    child: ListView(
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                      // height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: userName,
                        style: myTextStyle(),
                        obscuringCharacter: '*',
                        onChanged: (val) {
                          setState(() {
                            userErrorText = null;
                          });
                        },
                        decoration:
                            myInputDecoration('User Name', userErrorText),
                      ),
                    ),
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
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                      // height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: confirmPassword,
                        style: myTextStyle(),
                        // obscureText: true,
                        // obscuringCharacter: '*',
                        onChanged: (val) {
                          setState(() {
                            confirmPasswordErrorText = null;
                          });
                        },
                        decoration: myInputDecoration(
                            'Password', confirmPasswordErrorText),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                      // height: 30,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TextField(
                        controller: location,
                        style: myTextStyle(),
                        // obscureText: true,
                        // obscuringCharacter: '*',
                        onChanged: (val) {
                          setState(() {
                            locationErrorText = null;
                          });
                        },
                        decoration:
                            myInputDecoration('Location', locationErrorText),
                      ),
                    ),
                  ],
                )),
                InkWell(
                  onTap: () {
                    validate(email, password);
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
                      'Register',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already Registered? ',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Text(
                          'Sign In',
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
    );
  }
}
