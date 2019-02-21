import 'dart:async';
import 'package:flutter/material.dart';
import 'oauth_page.dart';

class SplashPage extends StatefulWidget {

  static const String routeName = '/splash';

  @override
  _SplashPageState createState() => _SplashPageState();

}

class _SplashPageState extends State<SplashPage> {

  Timer _countdownTimer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _countdownTimer = new Timer(new Duration(seconds: 2), (){
      handleImageTap();
    });
  }

  void handleImageTap() {
    Navigator.of(context).pushNamed(OauthPage.routeName);
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        child: GestureDetector(
          child: Image.asset('assets/images/common/splash_back.png'),
          onTap: handleImageTap,
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _countdownTimer.cancel();
    _countdownTimer = null;
    super.dispose();
  }

}

