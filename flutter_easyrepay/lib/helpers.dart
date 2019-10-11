import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


double _getTotalAmount(PBPerson person) {
  return person.transactions
    .fold(0.0, (value, t) {
      switch (t.type) {
        case PBTransactionType.CREDIT:
        case PBTransactionType.SETTLE_DEBT:
          return value + t.amount;
        case PBTransactionType.DEBT:
        case PBTransactionType.SETTLE_CREDIT:
          return value - t.amount;
        default:
          return value;
      }
    });
}


String _getAmountString(double amount) {
  var formatter = NumberFormat.simpleCurrency();
  return formatter.format(amount);
}


Text getTotalAmountText(PBPerson person, bool isTotalScreen) {
  var totalAmount = _getTotalAmount(person);
  return Text(
    "${_getAmountString(totalAmount >= 0 ? totalAmount : -totalAmount)}",
    style: TextStyle(
      color: (totalAmount >= 0 ? labelGreen : labelRed)
    ),
    textScaleFactor: isTotalScreen ? 1.5 : 1.2,
  );
}


Text getAmountText(PBTransaction transaction) {
  return Text(
    "${_getAmountString(transaction.amount)}",
    style: TextStyle(
      color: () {
        switch (transaction.type) {
          case PBTransactionType.CREDIT:
          case PBTransactionType.SETTLE_DEBT:
            return Colors.green[300];
          case PBTransactionType.DEBT:
          case PBTransactionType.SETTLE_CREDIT:
            return Colors.red[400];
          default:
            return Colors.purple;
        }
      }()
    ),
    textScaleFactor: 1.1,
  );
}


final amountTextFieldFormatter = () {
  var formatter = NumberFormat();
  formatter.maximumFractionDigits = 2;
  formatter.minimumFractionDigits = 2;
  formatter.maximumIntegerDigits = 12;
  return formatter;
}();


final deleteBackground = Container(
  padding: const EdgeInsets.only(right: 8),
  color: Colors.red[400],
  child: Column(
    children: <Widget>[
      Text("Delete", 
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


final primaryColor = Colors.green[800];
final accentColor = Colors.green[600];
final secondaryColor = Colors.grey[400];
final labelGreen = Colors.green[300];
final labelRed = Colors.red[400];