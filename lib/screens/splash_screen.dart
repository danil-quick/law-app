import 'dart:async';

import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/homeScreen');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      //  decoration: BoxDecoration(color: Colors.blue),
      // width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height,
      color: Colors.white,
      child: Center(
        child:Image.asset('assets/images/favicon_dark.png', fit: BoxFit.cover,)
      ),
    );
  }
  

}
