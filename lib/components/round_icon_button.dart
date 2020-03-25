import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final Function onTapDown;
//  final Function onTap;
  final Function onTapUp;
  final Function onTapCancel;
  final IconData icon;
  RoundIconButton(
      {this.icon,
      @required this.onTapUp,
//      @required this.onTap,
      @required this.onTapDown,
      @required this.onTapCancel});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
//      onTap: this.onTap,
      onTapDown: this.onTapDown,
      onTapUp: this.onTapUp,
      onTapCancel: this.onTapCancel,
      child: RawMaterialButton(
          onPressed: () {},
          shape: CircleBorder(),
          elevation: 6,
          child: Container(
            width: 56,
            height: 56,
            child: Icon(this.icon),
          ),
          fillColor: Color(0xFF4C4F5E)),
    );
  }
}
