import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projectStore/src/routes/navigate.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  startTime() async {
    // var _duration = new Duration(seconds: 5);
    return new Timer(Duration(seconds: 3), () => Navigate().gotoLogin(context));
    // return new Timer(Duration(seconds: 3), () => Navigate().gotoHome(context));
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Colors.redAccent,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 75.0,
                        child: new Image.asset(
                          'assets/splash.png',
                          scale: 2.1,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(
                      backgroundColor: Colors.deepPurpleAccent,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "My Store",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
