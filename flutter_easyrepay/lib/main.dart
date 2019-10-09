import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/views/people_list.dart';
import 'package:flutter/material.dart';


void main() => runApp(MaterialApp(
  title: "EasyRepay",
  home: PeopleList(),
  theme: ThemeData(
    primarySwatch: Colors.green,
    brightness: Brightness.dark,
    primaryColor: primaryColor,
    accentColor: accentColor,
    accentColorBrightness: Brightness.dark,
  ),
  debugShowCheckedModeBanner: false,
));