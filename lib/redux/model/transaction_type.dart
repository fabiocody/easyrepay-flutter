import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:easyrepay/views/theme.dart';
import 'package:flutter/material.dart';

class TransactionType {
  static final TransactionType credit = TransactionType('Credit');
  static final TransactionType debt = TransactionType('Debt');
  static final TransactionType settleCredit = TransactionType('Settle credit');
  static final TransactionType settleDebt = TransactionType('Settle debt');

  static final List<TransactionType> values = List.unmodifiable([credit, debt, settleCredit, settleDebt]);

  final String _rawString;

  TransactionType(this._rawString);

  factory TransactionType.fromPB(PBTransactionType pb) {
    switch (pb) {
      case PBTransactionType.CREDIT:
        return credit;
      case PBTransactionType.DEBT:
        return debt;
      case PBTransactionType.SETTLE_CREDIT:
        return settleCredit;
      case PBTransactionType.SETTLE_DEBT:
        return settleDebt;
      default:
        return null;
    }
  }

  PBTransactionType get protobuf {
    if (this == TransactionType.credit) {
      return PBTransactionType.CREDIT;
    } else if (this == TransactionType.debt) {
      return PBTransactionType.DEBT;
    } else if (this == TransactionType.settleCredit) {
      return PBTransactionType.SETTLE_CREDIT;
    } else if (this == TransactionType.settleDebt) {
      return PBTransactionType.SETTLE_DEBT;
    } else {
      return null;
    }
  }

  String string(BuildContext context) => AppLocalizations.of(context).translate(_rawString);

  Color get color {
    if (this == TransactionType.credit)
      return DarkColors.lightGreen;
    else if (this == TransactionType.debt)
      return DarkColors.orange;
    else if (this == TransactionType.settleCredit)
      return DarkColors.teal;
    else if (this == TransactionType.settleDebt) return DarkColors.magenta;
    return null;
  }

  get addOrSub {
    if (this == TransactionType.credit || this == TransactionType.settleDebt)
      return (v1, v2) => v1 + v2;
    else if (this == TransactionType.debt || this == TransactionType.settleCredit) return (v1, v2) => v1 - v2;
    return (v, _) => v;
  }

  bool operator ==(o) => o is TransactionType && _rawString == o._rawString;
  int get hashCode => _rawString.hashCode;
}
