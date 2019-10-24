import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


final amountTextFieldFormatter = () {
  var formatter = NumberFormat();
  formatter.maximumFractionDigits = 2;
  formatter.minimumFractionDigits = 2;
  formatter.maximumIntegerDigits = 12;
  return formatter;
}();


final currencyFormatter = NumberFormat.simpleCurrency();


class DarkColors {
  static final lightGreen = Color.fromRGBO(0x1e, 0xb9, 0x80, 1);
  static final green = Color.fromRGBO(0x00, 0x7d, 0x52, 1);
  static final teal = Colors.teal[700];
  static final orange = Color.fromRGBO(0xff, 0x68, 0x59, 1);
  static final magenta = Color.fromRGBO(0xc0, 0x3e, 0x69, 1);
  static final yellow = Color.fromRGBO(0xff, 0xcf, 0x44, 1);
  static final purple = Color.fromRGBO(0xb1, 0x5d, 0xff, 1);
  static final blue = Color.fromRGBO(0x72, 0xde, 0xff, 1);
  static final darkGrey = Color.fromRGBO(0x12, 0x12, 0x12, 1);
  static final surfaceOverlay = Color.fromRGBO(0x1b, 0x1b, 0x1b, 1);
}


final deleteBackground = Container(
  padding: const EdgeInsets.only(right: 8),
  color: Colors.red[400],
  child: Column(
    children: <Widget>[
      Text(
        'Delete',
        style: TextStyle(
          fontSize: 16, 
          color: Colors.white
        ),
      ),
    ],
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.end,
  ),
);
