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
  primaryColor: primarySwatch[700],
  primaryColorLight: primarySwatch[100],
  primaryColorDark: primarySwatch[800],
  toggleableActiveColor: primarySwatch[600], // or [200]
  accentColor: primarySwatch[500],  // or [200]
  canvasColor: Colors.grey[900],
);


void main() => runApp(MaterialApp(
  title: "EasyRepay",
  home: PeopleList(),
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: ThemeMode.system,
  debugShowCheckedModeBanner: false,
));