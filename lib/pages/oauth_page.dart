
import 'package:flutter/material.dart';
import 'package:flutter_wb/model/access_model.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:flutter_wb/common/common.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OauthPage extends StatefulWidget {

  static const String routeName = '/oauth';

  @override
  _OauthPageState createState() => _OauthPageState();

}

class _OauthPageState extends State<OauthPage> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    String dataURL = "https://api.weibo.com/oauth2/authorize?client_id=" + APP_KEY + "&response_type=code&redirect_uri=" + REDIRECT_URI;
    return WebviewScaffold(
        url: dataURL,
        appBar: new AppBar(
          title: new Text("微博认证"),
          backgroundColor: Colors.blueAccent
        ),
        withZoom: true,
        initialChild: Container(
          color: Colors.redAccent,
          child: const Center(
            child: Text('Waiting...'),
          ),
        ),
      );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final webviewPligin = new FlutterWebviewPlugin();
    webviewPligin.onUrlChanged.listen((String url) {
      String code = url.replaceFirst('https://api.weibo.com/oauth2/default.html?code=', '');
      getAccessToken(code);
    });

  }

  void getAccessToken(String code) async {
    String url = "https://api.weibo.com/oauth2/access_token?client_id="+APP_KEY+"&client_secret="+APP_SECRET+"&grant_type=authorization_code&redirect_uri="+REDIRECT_URI+"&code="+code;
    http.Response response = await http.post(url);
    AccessModel accessModel = AccessModel.fromJson(json.decode(response.body));
    kAccessToken = accessModel.access_token;

  }

}
