import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/Global/GlobalData.dart';
import 'package:newsapp/Landing.dart';
import 'Login.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int animationLevel = 0;

  @override
  void initState() {
    startAnimation();
    // TODO: implement initState
    super.initState();
  }

  startAnimation() async {
    if (animationLevel < 6) {
      setState(() {
        animationLevel++;
      });
      Future.delayed(const Duration(seconds: 1), () {
        startAnimation();
      });
    } else {
      FirebaseAuth auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        print(auth.currentUser.uid);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Landing()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          alignment: Alignment.center,
          height: animationLevel < 2 ? MediaQuery.of(context).size.height : 80,
          width: animationLevel < 2 ? MediaQuery.of(context).size.height : 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [startColor, endColor]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: AnimatedOpacity(
            duration: Duration(seconds: 1),
            opacity: animationLevel < 4 ? 0 : 1,
            child: Text(
              'The\n News',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
            ),
          ),
        ),
      ),
    ));
  }
}
