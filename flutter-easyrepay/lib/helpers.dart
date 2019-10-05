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
      color: (totalAmount >= 0 ? Colors.green : Colors.red)
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
            return Colors.green;
          case PBTransactionType.DEBT:
          case PBTransactionType.SETTLE_CREDIT:
            return Colors.red;
          default:
            return Colors.purple;
        }
      }()
    ),
    textScaleFactor: 1.1,
  );
}


var deleteBackground = Container(
  padding: const EdgeInsets.only(right: 8),
  color: Colors.red,
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