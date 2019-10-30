import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:easyrepay/redux/model/transaction.dart';
import 'package:easyrepay/redux/model/transaction_type.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class Person {
  final String id;
  final String name;
  final List<Transaction> transactions;
  final bool reminderActive;
  final DateTime reminderDate;

  Person(this.id, this.name, transactions, this.reminderActive, this.reminderDate):
    this.transactions = List.unmodifiable(List.from(transactions));

  factory Person.initial(String name) => 
    Person(Uuid().v4(), name, [], false, null);

  factory Person.fromPB(PBPerson pb) =>
    Person(pb.id,
           pb.name,
           pb.transactions.map((t) => Transaction.fromPB(t)).toList(),
           pb.reminderActive,
           DateTime.fromMillisecondsSinceEpoch(pb.reminderTimestamp.toInt() * 1000));

  PBPerson get protobuf {
    var p = PBPerson();
    p.id = id;
    p.name = name;
    p.transactions.addAll(transactions.map((t) => t.protobuf));
    p.reminderActive = reminderActive;
    p.reminderTimestamp = reminderDate == null ? Int64(0) : Int64(reminderDate.millisecondsSinceEpoch ~/ 1000);
    return p;
  }

  int get transactionsCount =>
    transactions.where((t) => !t.completed).length;

  Person clone() => 
    Person(id, name, transactions.map((t) => t.clone()), reminderActive, reminderDate);

  Person copyWith({String name, List<Transaction> transactions, bool reminderActive, DateTime reminderDate}) {
    var tt = transactions == null ? this.transactions : transactions;
    tt = tt.map((t) => t.clone());
    return Person(id, name ?? this.name, tt, reminderActive ?? this.reminderActive, reminderDate ?? this.reminderDate);
  }

  double _sumFold(double value, Transaction t) =>
    t.type.addOrSub(value, t.amount);

  Text getTotalAmountTextTile(BuildContext context) {
    var amount = transactions
      .where((t) => !t.completed)
      .fold(0.0, _sumFold);
    return Text(
      AppLocalizations.of(context).currencyFormatter.format(amount.abs()),
      style: Theme.of(context).textTheme.title.copyWith(
        color: amount.isNegative ? DarkColors.orange : DarkColors.lightGreen
      )
    );
  }

  Text getCreditAmountText(BuildContext context) {
    var amount = transactions
      .where((t) => !t.completed && (t.type == TransactionType.credit || t.type == TransactionType.settleDebt))
      .fold(0.0, _sumFold);
    return Text(
      AppLocalizations.of(context).currencyFormatter.format(amount.abs()),
      style: Theme.of(context).textTheme.display1.copyWith(color: DarkColors.lightGreen)
    );
  }

  Text getDebtAmountText(BuildContext context) {
    var amount = transactions
      .where((t) => !t.completed && (t.type == TransactionType.debt || t.type == TransactionType.settleCredit))
      .fold(0.0, _sumFold);
    return Text(
      AppLocalizations.of(context).currencyFormatter.format(amount.abs()),
      style: Theme.of(context).textTheme.display1.copyWith(color: DarkColors.orange)
    );
  }

  Text getTotalAmountText(BuildContext context) {
    var amount = transactions
      .where((t) => !t.completed)
      .fold(0.0, _sumFold);
    return Text(
      AppLocalizations.of(context).currencyFormatter.format(amount.abs()),
      style: Theme.of(context).textTheme.display1.copyWith(
        color: amount.isNegative ? DarkColors.orange : DarkColors.lightGreen
      )
    );
  }
}