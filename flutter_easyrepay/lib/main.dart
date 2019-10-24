import 'package:easyrepay/views/people_list.dart';
import 'package:flutter/material.dart';

var primarySwatch = Colors.green;

var lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: primarySwatch,
);

var darkTheme = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: primarySwatch,
  primaryColor: Colors.grey[900], //primarySwatch[700],
  primaryColorDark: primarySwatch[600],
  primaryColorLight: primarySwatch[400],
  toggleableActiveColor: primarySwatch[300], // or [200]
  accentColor: primarySwatch[500],  // or [200]
  canvasColor: Color.fromRGBO(0x12, 0x12, 0x12, 1.0),
);


void main() => runApp(MaterialApp(
  title: "EasyRepay",
  home: PeopleList(),
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: ThemeMode.dark,
  //debugShowCheckedModeBanner: false,
));