import 'package:flutter/material.dart';
import '../common/common.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/status_model.dart';
import '../widgets/nav_button.dart';
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';

class MainPage extends StatefulWidget {

  static const String routeName = '/main_page';

  @override
  MainPageState createState() => MainPageState();

}

class MainPageState extends State<MainPage> {

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  List<StatusModel> models = [];

  bool isLoadSuccess = false;

  var _errorMsg = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          NavButton(),
          AddButton(),
        ],
        backgroundColor: Colors.white70,
      ),
      body: _getBody(),
    );
  }

  void getData() async {
      String url = urls[URLType.home]+'?access_token='+kAccessToken;
      http.Response response = await http.get(url);
      MainModel mainModel = MainModel.fromJson(json.decode(response.body));
      setState(() {
        isLoadSuccess = (response.statusCode == 200);
        if (response.statusCode == 200) {
          models.insertAll(0, mainModel.statuses);
        }else {
          _errorMsg = response.reasonPhrase;
        }
      });
  }

  Future<void> _handleRefresh() async {
    final Completer<void> completer = Completer<void>();
    String url = urls[URLType.home]+'?access_token=' + kAccessToken + '&?since_id=' + '${models.first.id}';
    http.Response response = await http.get(url);
    MainModel mainModel = MainModel.fromJson(json.decode(response.body));
    int count = mainModel.statuses.length ?? 0;
    setState(() {
      if ( count > 0) {
        models.insertAll(0, mainModel.statuses);
      }
    });
    completer.complete();
    playLocal();
    return completer.future.then<void>((_){
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
          content: Text('更新了' + '${count}' + '条微博'),
          action: SnackBarAction(
              label: 'Retry',
              onPressed: () {
                _refreshIndicatorKey.currentState.show();
              }
          )
      ));
    });
  }

  Widget _getBody() {
    if (!isLoadSuccess) {
      return Center(
        child: GestureDetector(
          child: Text(_errorMsg,
            style: TextStyle(
              color: Colors.cyan,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: getData,
        )
      );
    }
    return RefreshIndicator(
        child: _getListView(),
        onRefresh: _handleRefresh
    );
  }

  ListView _getListView() => ListView.builder(
      itemCount: models.length,
      itemBuilder: (BuildContext context,int position){
        return _getRow(position);
      });

  Widget _getRow(int i) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Text(models[i].text ?? '')
      );
  }

  playLocal() async {
    AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
    assetsAudioPlayer.open(AssetsAudio(asset: 'msgcome.mp3',folder: 'assets/sound/'));
    assetsAudioPlayer.play();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }


}