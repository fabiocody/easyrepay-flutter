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


final deleteBackground = Container(
  padding: const EdgeInsets.only(right: 8),
  color: Colors.red[400],
  child: Column(
    children: <Widget>[
      Text(
        "Delete",
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
