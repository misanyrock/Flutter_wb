import 'package:flutter/material.dart';
import 'package:flutter_wb/pages/splash.dart';
import 'package:flutter_wb/pages/oauth_page.dart';
import 'package:flutter_wb/pages/main_page.dart';


class PageItem {

  const PageItem({
    @required this.routeName,
    @required this.buildRoute,
    @required this.title,
    this.subtitle,

  }) :  assert(buildRoute != null),
        assert(routeName != null),
        assert(title != null);

  final String routeName;
  final String title;
  final String subtitle;
  final WidgetBuilder buildRoute;

  @override
  String toString() {
    // TODO: implement toString
    return '$runtimeType($title $routeName)';
  }
}

List<PageItem> _buildPageItems() {
  final List<PageItem> pageItems = <PageItem>[
    PageItem(
        routeName: SplashPage.routeName,
        buildRoute: (BuildContext context) => SplashPage(),
        title: '闪屏页',
        subtitle: 'splash page'
      ),
    PageItem(
        routeName: OauthPage.routeName,
        buildRoute: (BuildContext context) => OauthPage(),
        title: '微博认证'
    ),
    PageItem(routeName: MainPage.routeName,
        buildRoute: (BuildContext context) => MainPage(),
        title: '首页'
    ),
  ];

  assert(() {
    pageItems.insert(0,
      PageItem(
        title: 'Pesto',
        subtitle: 'Simple recipe browser',
        routeName: '/pesto',
        buildRoute: (BuildContext context) => SplashPage(),
      ),
    );
    return true;
  }());
  return pageItems;
}


final List<PageItem> kAllPages = _buildPageItems();

enum RouteType {
  home,
  splash,
}

final Map<RouteType,String> routeMap = {
  RouteType.home : MainPage.routeName,
  RouteType.splash : SplashPage.routeName,
};







