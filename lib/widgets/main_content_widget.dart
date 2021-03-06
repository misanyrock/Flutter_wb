import 'package:flutter/material.dart';
import '../model/status_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';
import 'video_player.dart';
import 'dart:async';

typedef PictureTapCallback = void Function(int index,StatusModel model);
const double _kMinFlingVelocity = 800.0;

class MainContentWidget extends StatefulWidget {

  MainContentWidget(this.statusModel,{Key,key}) :  super(key: key);

  final StatusModel statusModel;

  @override
  _MainContentWidgetState createState() => _MainContentWidgetState(statusModel);
}

class _MainContentWidgetState extends State<MainContentWidget> {

  _MainContentWidgetState(this.statusModel) : super();
  final StatusModel statusModel;

  var imageCount = 0;
  VideoPlayerController controller;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final Completer<void> connectedCompleter = Completer<void>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    if (statusModel.retweeted_status != null) {
      return _retweetedWidget(statusModel.retweeted_status);
    }

    if (statusModel.pic_urls != null) {
      imageCount = statusModel.pic_urls.length;
      if (imageCount > 0) return _picsWidget();
    }

    if (statusModel.text.contains("http://")) {
      List<String> urls =  statusModel.text.split('http');
      String videoUrl = 'http' + urls.last;
      return _videoWidget(videoUrl);
    }

    return Text('placehold');
  }

  Widget _retweetedWidget(RetweetedStatusModel model) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.black12,
      child: Padding(padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('@' + model.user.screen_name + ':' + model.text),
          ],
        ),
      ),
    );
  }


  Future<void> initController(VideoPlayerController controller) async {
    controller.setLooping(true);
    controller.setVolume(0.0);
    controller.play();
    await connectedCompleter.future;
    await controller.initialize();
    if (mounted)
      setState(() {});
  }


  Widget _videoWidget(String url) {

    controller = VideoPlayerController.network(url);
    initController(controller);

    Widget fullScreenRoutePageBuilder(BuildContext context,
        Animation<double> animation, Animation<double> secondaryAnimation) {
      return _buildFullScreenVideo();
    }

    void pushFullScreenWidget() {
      final TransitionRoute<void> route = PageRouteBuilder<void>(
        settings: RouteSettings(name: 'pic_full_route', isInitialRoute: false),
        pageBuilder: fullScreenRoutePageBuilder,
      );

      route.completed.then((void value) {
        controller.setVolume(0.0);
      });

      controller.setVolume(1.0);
      Navigator.of(context).push(route);
    }

    return ConnectivityOverlay(
      child: Column(
        children: <Widget>[
          //ListTile(title: Text('123'), subtitle: Text('456')),
          GestureDetector(
            onTap: pushFullScreenWidget,
            child: _buildInlineVideo(),
          ),
        ],
      ),
      connectedCompleter: connectedCompleter,
      scaffoldKey: scaffoldKey,
    );
  }

  Widget _picsWidget() {
    final Size screenSize = MediaQuery.of(context).size;
    double height = 100;
    if (imageCount > 2){
      height = 300;
    } else if (imageCount == 2) {
      height = 200;
    }
    return  Container(
        width: screenSize.width,
        height: height,
        child: GridView.count(
          scrollDirection: Axis.horizontal,
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          children: statusModel.pic_urls.map<Widget>((PictureInfoModel pic){
            return GestureDetector(
              onTap: (){_handlePicTap();},
              child: CachedNetworkImage(imageUrl: pic.thumbnail != null ? pic.thumbnail : pic.thumbnail_pic,
              fit: BoxFit.cover,
              ),
            );
          }).toList(),
        )
    );
  }

  void _handlePicTap() {
    print('tap pic');
  }

  Widget _buildInlineVideo() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 30.0),
      child: Center(
        child: AspectRatio(
            aspectRatio: 3.6 / 2,
            child: Hero(
              tag: controller,
              child: VideoPlayerLoading(controller),
            ),
          ),
      ),
    );
  }

  Widget _buildFullScreenVideo() {
    return Scaffold(
      appBar: AppBar(
        title: Text('123'),
      ),
      body: Center(
        child: AspectRatio(
          aspectRatio: 3.6 / 2,
          child: Hero(
            tag: controller,
            child: VideoPlayPause(controller),
          ),
        ),
      ),
    );
  }

}


class PictureViewer extends StatefulWidget {

  static const String routeName = '/picture_viewer_page';

  const PictureViewer({Key key, this.index, this.model}) : super(key:key);

  final int index;
  final StatusModel model;

  @override
  _PictureViewerState createState() => _PictureViewerState();

}

class _PictureViewerState extends State<PictureViewer> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation<Offset> _flingAnimation;
  Offset _offset = Offset.zero;
  double _scale = 1.0;
  Offset _normalizedOffset;
  double _previousScale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)..addListener(_handleFlingAnimation);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onScaleStart: _handleOnScaleStart,
      onScaleUpdate: _handleOnScaleUpdate,
      onScaleEnd: _handleOnScaleEnd,
      child: ClipRect(
        child: Transform(transform: Matrix4.identity()
            ..translate(_offset.dx,_offset.dy)
            ..scale(_scale),
            child: new CachedNetworkImage(imageUrl: ""),
        ),
      ),
    );
  }

  void _handleFlingAnimation() {
    setState(() {
      _offset = _flingAnimation.value;
    });
  }

  // The maximum offset value is 0,0. If the size of this renderer's box is w,h
  // then the minimum offset value is w - _scale * w, h - _scale * h.
  Offset _clampOffset(Offset offset) {
    final Size size = context.size;
    final Offset minOffset = Offset(size.width, size.height) * (1.0 - _scale);
    return Offset(offset.dx.clamp(minOffset.dx, 0.0), offset.dy.clamp(minOffset.dy, 0.0));
  }


  void _handleOnScaleStart(ScaleStartDetails details) {
    setState(() {
      _previousScale = _scale;
      _normalizedOffset = (details.focalPoint - _offset) / _scale;
      // The fling animation stops if an input gesture starts.
      _controller.stop();
    });
  }

  void _handleOnScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _scale = (_previousScale * details.scale).clamp(1.0, 4.0);
      // Ensure that image location under the focal point stays in the same place despite scaling.
      _offset = _clampOffset(details.focalPoint - _normalizedOffset * _scale);
    });
  }

  void _handleOnScaleEnd(ScaleEndDetails details) {

    final double magnitude = details.velocity.pixelsPerSecond.distance;
    if (magnitude < _kMinFlingVelocity)
      return;
    final Offset direction = details.velocity.pixelsPerSecond / magnitude;
    final double distance = (Offset.zero & context.size).shortestSide;
    _flingAnimation = _controller.drive(Tween<Offset>(
        begin: _offset,
        end: _clampOffset(_offset + direction * distance)
    ));
    _controller
      ..value = 0.0
      ..fling(velocity: magnitude / 1000.0);
  }
}
