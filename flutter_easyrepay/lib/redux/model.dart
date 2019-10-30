import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class AppState {
  final List<Person> people;

  AppState(this.people);

  factory AppState.initial() => AppState(List.unmodifiable([]));

  factory AppState.debug() {
    var ppl = [];
    Person p;
    p = Person.initial('Brooklyn Thompson');
    p.transactions.add(Transaction.initial(type: TransactionType.debt, amount: 4.5, description: 'Pizza'));
    p.transactions.add(Transaction.initial(type: TransactionType.credit, amount: 15, description: 'Pocket money'));
    p.transactions.add(Transaction.initial(type: TransactionType.credit, amount: 7, description: 'Lunch', completed: true));
    ppl.add(p);
    p = Person.initial('Steve Wilkins');
    ppl.add(p);
    p = Person.initial('Arthur Ford');
    p.transactions.add(Transaction.initial(type: TransactionType.debt, amount: 7.8, description: 'Pens'));
    ppl.add(p);
    p = Person.initial('Liam Mcmillan');
    p.transactions.add(Transaction.initial(type: TransactionType.debt, amount: 4.99, description: 'Some debt'));
    p.transactions.add(Transaction.initial(type: TransactionType.settleDebt, amount: 4.99, description: 'Some debt'));
    p.transactions.add(Transaction.initial(type: TransactionType.credit, amount: 9.99, description: 'Some credit'));
    p.transactions.add(Transaction.initial(type: TransactionType.settleCredit, amount: 9.99, description: 'Some credit'));
    ppl.add(p);
    p = Person.initial('Maggie Nicholls');
    p.transactions.add(Transaction.initial(type: TransactionType.debt, amount: 12, description: 'CDs'));
    ppl.add(p);
    ppl.sort((p1, p2) => p1.name.compareTo(p2.name));
    return AppState(List.unmodifiable(ppl));
  }

  factory AppState.fromPB(PBDataStore pb) {
    return AppState(List.unmodifiable(pb.people.map((p) => Person.fromPB(p)).toList()));
  }

  PBDataStore get protobuf {
    var store = PBDataStore();
    store.people.addAll(people.map((p) => p.protobuf));
    return store;
  }

  void save() {

  }
}


class Person {
  final String id;
  final String name;
  final List<Transaction> transactions;
  final bool reminderActive;
  final DateTime reminderDate;

  Person(this.id, this.name, this.transactions, this.reminderActive, this.reminderDate);

  factory Person.initial(String name) => 
    Person(Uuid().v4(), name, List.unmodifiable([]), false, null);

  factory Person.from(Person p) => 
    Person(p.id, p.name, List.unmodifiable(p.transactions.map((t) => Transaction.from(t))), p.reminderActive, p.reminderDate);

  factory Person.fromPB(PBPerson pb) =>
    Person(pb.id, 
           pb.name, 
           List.unmodifiable(pb.transactions.map((t) => Transaction.fromPB(t)).toList()),
           pb.reminderActive, 
           DateTime.fromMillisecondsSinceEpoch(pb.reminderTimestamp.toInt() * 1000));

  PBPerson get protobuf {
    var p = PBPerson();
    p.id = id;
    p.name = name;
    p.transactions.addAll(transactions.map((t) => t.protobuf).toList());
    p.reminderActive = reminderActive;
    p.reminderTimestamp = reminderDate == null ? Int64(0) : Int64(reminderDate.millisecondsSinceEpoch ~/ 1000);
    return p;
  }

  int get transactionsCount =>
    transactions.where((t) => !t.completed).length;

  void sortTransactions() =>
    transactions.sort((t1, t2) => t1.date.compareTo(t2.date));

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


class Transaction {
  final String id;
  final TransactionType type;
  final double amount;
  final String description;
  final bool completed;
  final DateTime date;

  Transaction(this.id, this.type, this.amount, this.description, this.completed, this.date);

  factory Transaction.initial({type, amount=0, description='', completed=false, date}) => 
    Transaction(Uuid().v4(), 
                type == null ? TransactionType.credit : type, 
                amount, 
                description, 
                completed, 
                date == null ? DateTime.now() : date);

  factory Transaction.from(Transaction t) =>
    Transaction(t.id, t.type, t.amount, t.description, t.completed, t.date);

  factory Transaction.fromPB(PBTransaction pb) =>
    Transaction(pb.id,
                TransactionType.fromPB(pb.type),
                pb.amount,
                pb.description,
                pb.completed,
                DateTime.fromMillisecondsSinceEpoch(pb.timestamp.toInt() * 1000));

  PBTransaction get protobuf {
    var t = PBTransaction();
    t.id = id;
    t.type = type.protobuf;
    t.amount = amount;
    t.description = description;
    t.completed = completed;
    t.timestamp = Int64(date.millisecondsSinceEpoch ~/ 1000);
    return t;
  }
}


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
    else if (this == TransactionType.settleDebt)
      return DarkColors.magenta;
    return null;
  }

  get addOrSub {
    if (this == TransactionType.credit || this == TransactionType.settleDebt)
      return (v1, v2) => v1 + v2;
    else if (this == TransactionType.debt || this == TransactionType.settleCredit)
      return (v1, v2) => v1 - v2;
    return (v, _) => v;
  }

  bool operator ==(o) => o is TransactionType && _rawString == o._rawString;
  int get hashCode => _rawString.hashCode;
}