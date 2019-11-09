import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/redux/model/transaction_type.dart';
import 'package:easyrepay/views/theme.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class Transaction {
  final String id;
  final String personID;
  final TransactionType type;
  final double amount;
  final String description;
  final bool completed;
  final DateTime date;

  Transaction(this.id, this.personID, this.type, this.amount, this.description, this.completed, this.date);

  factory Transaction.initial({personID, type, double amount=0.0, description='', completed=false, date}) =>
    Transaction(Uuid().v4(), 
                personID ?? Uuid().v4(),
                type == null ? TransactionType.credit : type, 
                amount, 
                description, 
                completed, 
                date ?? DateTime.now());

  Transaction copyWith({String personID, TransactionType type, double amount, String description, bool completed, DateTime date}) =>
    Transaction(this.id, personID ?? this.personID, type ?? this.type, amount ?? this.amount, description ?? this.description, completed ?? this.completed, date ?? this.date);

  Text getAmountText(BuildContext context) {
    return Text(
      AppLocalizations.of(context).currencyFormatter.format(amount.abs()),
      style: Theme.of(context).textTheme.title.copyWith(
        color: type.color,
        fontFamily: FontFamilies.numbers,
      )
    );
  }

  bool operator ==(o) => o is Transaction && id == o.id && personID == o.personID && type == o.type && amount == o.amount && description == o.description && date == o.date;
  int get hashCode => id.hashCode;
}