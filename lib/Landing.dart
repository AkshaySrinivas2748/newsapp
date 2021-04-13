import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:newsapp/Network/Network_Sensitive.dart';
import 'package:newsapp/Network/connectivity_status.dart';
import 'package:url_launcher/url_launcher.dart';
import 'Global/GlobalData.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'Login.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  Widget body;
  ConnectivityStatus status;
  List<NewsData> news = [];
  String newsUrl =
      'https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=306162b04f964de38c4dda8d87f2e84f';
  DateTime currentBackPressTime;

  getUserData() {
    print('Getting user Data');
    FirebaseAuth auth = FirebaseAuth.instance;
    print(auth.currentUser);
    print('User Data: ${auth.currentUser.providerData}');
    if (auth.currentUser != null) {
      String name = auth.currentUser.displayName;
      String email = auth.currentUser.email;
      // Uri photoURL = Uri(auth.currentUser.photoURL);
      String uid = auth.currentUser.uid;
      print('Name:$name');
      print('Email:$email');
      print('UID:$uid');
    }
  }

  getNews(articles) {
    for (int i = 0; i < articles.length; i++) {
      news.add(NewsData());
      news[i].author = articles[i]['author'];
      news[i].title = articles[i]['title'];
      news[i].description = articles[i]['description'];
      news[i].url = articles[i]['url'];
      news[i].urlToImage = articles[i]['urlToImage'];
      news[i].publishedAt = articles[i]['publishedAt'];
      news[i].content = articles[i]['content'];
    }
  }

  Future<void> loadBody() async {
    setState(() {
      body = FutureBuilder(
        future: http.get(Uri.parse(newsUrl)),
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            return Center(
              child: Text('Something Error'),
            );
          } else if (snapShot.hasData) {
            var temp = jsonDecode(snapShot.data.body)['articles'];
            getNews(temp);
            return ListView.builder(
                padding: EdgeInsets.only(bottom: 20),
                itemCount: news.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      print('tapped');
                      // _launchInWebViewOrVC(news[index].url);
                      _launchInBrowser(news[index].url);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey,
                                offset: Offset(0, 0),
                                blurRadius: 2)
                          ]),
                      child: Column(
                        children: [
                          Image(
                            image: NetworkImage(news[index].urlToImage),
                          ),
                          SizedBox(height: 10),
                          Text(
                            news[index].title,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                          SizedBox(height: 10),
                          // Text(news[index].description,
                          //     style: TextStyle(fontSize: 18)),
                          Text(news[index].description,
                              textAlign: TextAlign.justify,
                              style: TextStyle(fontSize: 16)),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text('by-${news[index].author}',
                                style: TextStyle(fontSize: 14)),
                          )
                        ],
                      ),
                    ),
                  );
                });
          } else
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(startColor)));
        },
      );
    });
    return true;
  }

  @override
  void initState() {
    // status = Provider.of<ConnectivityStatus>(context);
    // Connectivity().onConnectivityChanged;
    // print('Status:$status');
    loadBody();
    getUserData();
    // TODO: implement initState
    super.initState();
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
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
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              title: Text('The News'),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: <Color>[startColor, endColor])),
              ),
              actions: [
                InkWell(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 20),
                    alignment: Alignment.center,
                    child: Text(
                      'logout',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                )
              ],
            ),
            body: RefreshIndicator(
              color: startColor,
              onRefresh: loadBody,
              child: Container(
                color: Colors.grey.withOpacity(0.5),
                child: body,
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
