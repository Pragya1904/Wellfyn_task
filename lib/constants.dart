import 'package:flutter/material.dart';

const primaryColor=Color(0xff381a60);
//home_page constants

const dateStyle=TextStyle(color: Colors.red,fontSize: 15,fontWeight: FontWeight.bold);
const navStyle=TextStyle(color: Colors.green,fontSize: 15,fontWeight: FontWeight.bold);
const dataStyle=TextStyle(fontWeight: FontWeight.bold,fontSize: 15);

//login_page constants
const kTextFieldDecoration=InputDecoration(
  hintText: '',
  hintStyle: TextStyle(color: Colors.grey),
  labelText: "Email ID",
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: primaryColor, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color:primaryColor, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

const kButtonTextStyle=TextStyle(
  color: Colors.black,
);