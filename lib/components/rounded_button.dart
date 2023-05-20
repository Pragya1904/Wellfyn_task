import 'package:flutter/material.dart';
class RoundedButton1 extends StatelessWidget {
  const RoundedButton1({this.colour,this.title1,@required this.onPressed});
  final colour;
  final title1;
  final onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed:onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            title1,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}