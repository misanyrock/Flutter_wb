

import 'package:flutter/material.dart';


class NavButton extends StatelessWidget {

  const NavButton({ Key key,this.action }) : super(key: key);

  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.camera_alt,color: Colors.white70),
        tooltip: 'take photo',
        onPressed: () => action
    );
  }
}

class AddButton extends StatelessWidget {

  const AddButton({ Key key,this.action }) : super(key: key);

  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.add_circle, color: Colors.deepOrangeAccent),
        tooltip: 'publish status',
        onPressed: () => action
    );
  }
}