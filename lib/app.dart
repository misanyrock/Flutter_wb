
import 'dart:async';
import 'package:flutter/material.dart';
import 'pages/splash.dart';
import 'common/routes.dart';

class WBApp extends StatefulWidget {

  const WBApp({
    Key key,
    this.testMode = false,
  }) : super(key: key);
  
  final bool testMode;

  @override
  _WBAppState createState() => _WBAppState();
}

class _WBAppState extends State<WBApp> {

  Timer _timeDilationTimer;

  Map<String,WidgetBuilder> _buildRoutes() {
    return Map<String,WidgetBuilder>.fromIterable(
      kAllPages,
      key: (dynamic item) => '${item.routeName}',
      value: (dynamic item) => item.buildRoute,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _timeDilationTimer.cancel();
    _timeDilationTimer = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget splash = SplashPage();

    return MaterialApp(
      color: Colors.white,
      title: 'Flutter WB',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(

      ),
      routes: _buildRoutes(),
      home: splash,
    );
  }

}

