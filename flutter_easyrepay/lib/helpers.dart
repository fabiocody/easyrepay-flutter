import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';


class DarkColors {
  static const lightGreen = Color.fromRGBO(0x1e, 0xb9, 0x80, 1);
  static const green = Color.fromRGBO(0x00, 0x7d, 0x52, 1);
  static const teal = Color.fromRGBO(0x00, 0x79, 0x6b, 1);
  static const orange = Color.fromRGBO(0xff, 0x68, 0x59, 1);
  static const magenta = Color.fromRGBO(0xc0, 0x3e, 0x69, 1);
  static const yellow = Color.fromRGBO(0xff, 0xcf, 0x44, 1);
  static const purple = Color.fromRGBO(0xb1, 0x5d, 0xff, 1);
  static const blue = Color.fromRGBO(0x72, 0xde, 0xff, 1);
  static const darkGrey = Color.fromRGBO(0x12, 0x12, 0x12, 1);
  static const surfaceOverlay = Color.fromRGBO(0x1a, 0x1a, 0x1a, 1);
  static const topBottomBar = Color.fromRGBO(0x1d, 0x1d, 0x1d, 1);
}


void vibrate(FeedbackType type) async {
  if (await Vibrate.canVibrate)
    Vibrate.feedback(type);
}