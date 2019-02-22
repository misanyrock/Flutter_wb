
// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class NavigationIconView {
  NavigationIconView({
    Widget child,
    Widget icon,
    Widget activeIcon,
    String title,
    Color color,
    TickerProvider vsync,
  }) : _icon = icon,
        _color = color,
        _child = child,
        _title = title,
        item = BottomNavigationBarItem(
          icon: icon,
          activeIcon: activeIcon,
          title: Text(title),
          backgroundColor: color,
        ),
        controller = AnimationController(
          duration: kThemeAnimationDuration,
          vsync: vsync,
        ) {
    _animation = controller.drive(CurveTween(
      curve: const Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
    ));
  }

  final Widget _child;
  final Widget _icon;
  final Color _color;
  final String _title;
  final BottomNavigationBarItem item;
  final AnimationController controller;
  Animation<double> _animation;

  FadeTransition transition(BottomNavigationBarType type, BuildContext context) {
    Color iconColor;
    if (type == BottomNavigationBarType.shifting) {
      iconColor = _color;
    } else {
      final ThemeData themeData = Theme.of(context);
      iconColor = themeData.brightness == Brightness.light
          ? themeData.primaryColor
          : themeData.accentColor;
    }

    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: _animation.drive(
          Tween<Offset>(
            begin: const Offset(0.0, 0.02), // Slightly down.
            end: Offset.zero,
          ),
        ),
        child: IconTheme(
          data: IconThemeData(
            color: iconColor,
            size: 120.0,
          ),
          child: Semantics(
            label: 'Placeholder for $_title tab',
            child: _child,
          ),
        ),
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return Container(
      margin: const EdgeInsets.all(4.0),
      width: iconTheme.size - 8.0,
      height: iconTheme.size - 8.0,
      color: iconTheme.color,
    );
  }
}

class CustomInactiveIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    return Container(
        margin: const EdgeInsets.all(4.0),
        width: iconTheme.size - 8.0,
        height: iconTheme.size - 8.0,
        decoration: BoxDecoration(
          border: Border.all(color: iconTheme.color, width: 2.0),
        )
    );
  }
}

//for (NavigationIconView view in _navigationViews)
//view.controller.dispose();

//int _currentIndex = 0;
//BottomNavigationBarType _type = BottomNavigationBarType.shifting;
//List<NavigationIconView> _navigationViews;


//_navigationViews = <NavigationIconView>[
//NavigationIconView(
//icon: const Icon(Icons.account_balance),
//title: 'Alarm',
//color: Colors.deepPurple,
//vsync: this,
//child: LayoutBuilder(builder: _buildStack),
//),
//NavigationIconView(
//activeIcon: const Icon(Icons.voice_chat),
//icon: const Icon(Icons.computer),
//title: 'Box',
//color: Colors.deepOrange,
//vsync: this,
//child: LayoutBuilder(builder: _buildStack),
//),
//NavigationIconView(
//activeIcon: const Icon(Icons.find_in_page),
//icon: const Icon(Icons.search),
//title: 'Cloud',
//color: Colors.teal,
//vsync: this,
//child: LayoutBuilder(builder: _buildStack),
//),
//NavigationIconView(
//activeIcon: const Icon(Icons.mail),
//icon: const Icon(Icons.mail_outline),
//title: 'Favorites',
//color: Colors.indigo,
//vsync: this,
//child: LayoutBuilder(builder: _buildStack),
//),
//NavigationIconView(
//activeIcon: const Icon(Icons.perm_contact_calendar),
//icon: const Icon(Icons.perm_identity),
//title: 'Event',
//color: Colors.pink,
//vsync: this,
//child: LayoutBuilder(builder: _buildStack),
//)
//];
//
//_navigationViews[_currentIndex].controller.value = 1.0;


//    final BottomNavigationBar botNavBar = BottomNavigationBar(
//      items: _navigationViews
//          .map<BottomNavigationBarItem>((NavigationIconView navigationView) => navigationView.item)
//          .toList(),
//      currentIndex: _currentIndex,
//      type: _type,
//      onTap: (int index) {
//        setState(() {
//          _navigationViews[_currentIndex].controller.reverse();
//          _currentIndex = index;
//          _navigationViews[_currentIndex].controller.forward();
//        });
//      },
//    );


//Widget _buildTransitionsStack() {
//  final List<FadeTransition> transitions = <FadeTransition>[];
//
//  for (NavigationIconView view in _navigationViews)
//    transitions.add(view.transition(_type, context));
//
//  // We want to have the newly animating (fading in) views on top.
//  transitions.sort((FadeTransition a, FadeTransition b) {
//    final Animation<double> aAnimation = a.opacity;
//    final Animation<double> bAnimation = b.opacity;
//    final double aValue = aAnimation.value;
//    final double bValue = bAnimation.value;
//    return aValue.compareTo(bValue);
//  });
//
//  return Stack(children: transitions);
//}

