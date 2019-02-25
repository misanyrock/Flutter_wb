import 'package:flutter/material.dart';
import '../common/common.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/status_model.dart';
import '../widgets/nav_button.dart';
import 'dart:async';
import 'package:assets_audio_player/assets_audio_player.dart';
import '../widgets/main_back.dart';
import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/main_content_widget.dart';

class MainPage extends StatefulWidget {

  static const String routeName = '/main_page';

  @override
  MainPageState createState() => MainPageState();

}

class MainPageState extends State<MainPage> with SingleTickerProviderStateMixin , TickerProviderStateMixin{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _backdropKey = GlobalKey(debugLabel: 'Backdrop');

  AnimationController _controller;
  Category _category = allCategories[0];

  List<StatusModel> models = [];

  //net
  bool isLoadSuccess = false;
  var _errorMsg = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      value: 1.0,
      vsync: this,
    );
    
    getData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0.0,
        title: BackdropTitle(
          listenable: _controller.view,
        ),
        actions: <Widget>[
          IconButton(
            onPressed: _toggleBackdropPanelVisibility,
            icon: AnimatedIcon(
              icon: AnimatedIcons.close_menu,
              semanticLabel: 'close',
              progress: _controller.view,
            ),
          ),
          NavButton(),
          AddButton(),
        ],
      ),
      body: LayoutBuilder(builder: _buildStack),
      //bottomNavigationBar: botNavBar,
    );
  }

  void getData() async {
      String url = urls[URLType.home]+'?access_token=' + kAccessToken + '&?feature=' + '${_category.feature}';
      print(url);
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
    String url = urls[URLType.home]+'?access_token=' + kAccessToken + '&?since_id=' + '${models.first.id}' + '&?feature=' + '${_category.feature}';
    print(url);
    http.Response response = await http.get(url);
    MainModel mainModel = MainModel.fromJson(json.decode(response.body));
    int count = mainModel.statuses.length ?? 0;
    completer.complete();
    playLocal();
    setState(() {
      if ( count > 0) { models.insertAll(0, mainModel.statuses);}
    });
    return completer.future.then<void>((_){
      _scaffoldKey.currentState?.showSnackBar(SnackBar(
        content: Text('更新了' + '${count}' + '条微博'),
        backgroundColor: Colors.orange,
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
    //print(models[i].pic_ids);
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                child: CircleAvatar(
                  backgroundImage: new CachedNetworkImageProvider(models[i].user.avatar_large),
                )
              ),
              SizedBox.fromSize(size: Size(8, 0),),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 100,
                    child: Text(models[i].user.screen_name ?? ''),
                  ),
                  SizedBox.fromSize(size: Size(0, 4),),
                  Container(
                    width: 250,
                    child: Text((models[i].user.description ?? '').length <= 30 ? (models[i].user.description ?? '') : models[i].user.description.substring(0,28),
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox.fromSize(size: Size(0, 8),),
          Text(models[i].text ?? ''),
          SizedBox.fromSize(size: Size(0, 8),),
          MainContentWidget(models[i]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              FlatButton.icon(
                onPressed: (){},
                icon: Icon(Icons.add_to_home_screen,color: Colors.grey,),
                label: Text(models[i].reposts_count > 0 ? '${models[i].reposts_count}' : '转发' ),
                textColor: Colors.grey,
              ),
              FlatButton.icon(
                onPressed: (){},
                icon: Icon(Icons.message,color: Colors.grey,),
                label: Text( models[i].comments_count > 0 ? '${models[i].comments_count}' : '评论'),
                textColor: Colors.grey,
              ),
              FlatButton.icon(
                onPressed: (){},
                icon: Icon(Icons.thumb_up,color: Colors.grey,),
                label: Text(models[i].attitudes_count > 0 ? '${models[i].attitudes_count}' : '赞'),
                textColor: Colors.grey,
              ),
            ],
          ),
        ],
      ),
      );
  }

  playLocal() async {
    AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
    assetsAudioPlayer.open(AssetsAudio(asset: 'msgcome.mp3',folder: 'assets/sound/'));
    assetsAudioPlayer.play();
  }




  /// for Backdrop


  void _changeCategory(Category category) {
    setState(() {
      _category = category;
      _controller.fling(velocity: 2.0);
      models.clear();
      getData();
    });
  }

  bool get _backdropPanelVisible {
    final AnimationStatus status = _controller.status;
    return status == AnimationStatus.completed || status == AnimationStatus.forward;
  }

  void _toggleBackdropPanelVisibility() {
    _controller.fling(velocity: _backdropPanelVisible ? -2.0 : 2.0);
  }

  double get _backdropHeight {
    final RenderBox renderBox = _backdropKey.currentContext.findRenderObject();
    return renderBox.size.height;
  }

  // By design: the panel can only be opened with a swipe. To close the panel
  // the user must either tap its heading or the backdrop's menu icon.

  void _handleDragUpdate(DragUpdateDetails details) {
    if (_controller.isAnimating || _controller.status == AnimationStatus.completed)
      return;

    _controller.value -= details.primaryDelta / (_backdropHeight ?? details.primaryDelta);
  }

  void _handleDragEnd(DragEndDetails details) {
    if (_controller.isAnimating || _controller.status == AnimationStatus.completed)
      return;

    final double flingVelocity = details.velocity.pixelsPerSecond.dy / _backdropHeight;
    if (flingVelocity < 0.0)
      _controller.fling(velocity: math.max(2.0, -flingVelocity));
    else if (flingVelocity > 0.0)
      _controller.fling(velocity: math.min(-2.0, -flingVelocity));
    else
      _controller.fling(velocity: _controller.value < 0.5 ? -2.0 : 2.0);
  }

  // Stacks a BackdropPanel, which displays the selected category, on top
  // of the backdrop. The categories are displayed with ListTiles. Just one
  // can be selected at a time. This is a LayoutWidgetBuild function because
  // we need to know how big the BackdropPanel will be to set up its
  // animation.
  Widget _buildStack(BuildContext context, BoxConstraints constraints) {
    const double panelTitleHeight = 48.0;
    final Size panelSize = constraints.biggest;
    final double panelTop = panelSize.height - panelTitleHeight;

    final Animation<RelativeRect> panelAnimation = _controller.drive(
      RelativeRectTween(
        begin: RelativeRect.fromLTRB(
          0.0,
          panelTop - MediaQuery.of(context).padding.bottom,
          0.0,
          panelTop - panelSize.height,
        ),
        end: const RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0),
      ),
    );

    final ThemeData theme = Theme.of(context);
    final List<Widget> backdropItems = allCategories.map<Widget>((Category category) {
      final bool selected = category == _category;
      return Material(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
        color: selected
            ? Colors.white.withOpacity(0.25)
            : Colors.transparent,
        child: ListTile(
          title: Text(category.title),
          selected: selected,
          onTap: () {
            _changeCategory(category);
          },
        ),
      );
    }).toList();

    return Container(
      key: _backdropKey,
      color: theme.primaryColor,
      child: Stack(
        children: <Widget>[
          ListTileTheme(
            iconColor: theme.primaryIconTheme.color,
            textColor: theme.primaryTextTheme.title.color.withOpacity(0.6),
            selectedColor: theme.primaryTextTheme.title.color,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: backdropItems,
              ),
            ),
          ),
          PositionedTransition(
            rect: panelAnimation,
            child: BackdropPanel(
              onTap: _toggleBackdropPanelVisibility,
              onVerticalDragUpdate: _handleDragUpdate,
              onVerticalDragEnd: _handleDragEnd,
              title: Text(_category.title),
              child: _getBody(),
            ),
          ),
        ],
      ),
    );
  }

}