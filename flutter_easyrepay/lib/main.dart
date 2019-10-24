import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/views/people_list.dart';
import 'package:flutter/material.dart';

var primarySwatch = Colors.green;

var lightTheme = ThemeData(
  brightness: Brightness.light,
  primarySwatch: primarySwatch,
);

var darkTheme = ThemeData(
  brightness: Brightness.dark,
  //primaryColor: DarkColors.darkGreen,
  primaryColorDark: DarkColors.lightGreen,
  accentColor: DarkColors.lightGreen,
  toggleableActiveColor: DarkColors.lightGreen,
  canvasColor: DarkColors.darkGrey,
  cardColor: DarkColors.surfaceOverlay,
  dialogBackgroundColor: DarkColors.surfaceOverlay,
);


void main() => runApp(MaterialApp(
  title: 'EasyRepay',
  home: PeopleList(),
  theme: lightTheme,
  darkTheme: darkTheme,
  themeMode: ThemeMode.dark,
  //debugShowCheckedModeBanner: false,
));