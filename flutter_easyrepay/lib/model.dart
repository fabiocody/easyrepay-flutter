import 'dart:io';
import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/proto/easyrepay.pbserver.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class DataStore {
  List<Person> people = [];

  static DataStore _store = DataStore();

  static DataStore shared() {
    return _store;
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/easyrepay_datastore.pb');
  }

  Future fillWithLocalData() async {
    try {
      final file = await _localFile;
      final bytes = await file.readAsBytes();
      final pbStore = PBDataStore.fromBuffer(bytes);
      people = pbStore.people.map((p) => Person.fromPB(p)).toList();
    } catch (e) {
      print(e);
      people = [];
    }
  }

  Future fillWithDebugData() async {
    people = [];
    Person p;
    p = Person('Brooklyn Thompson');
    p.transactions.add(Transaction(type: TransactionType.debt, amount: 4.5, description: 'Pizza'));
    p.transactions.add(Transaction(type: TransactionType.credit, amount: 15, description: 'Pocket money'));
    p.transactions.add(Transaction(type: TransactionType.credit, amount: 7, description: 'Lunch', completed: true));
    people.add(p);
    p = Person('Steve Wilkins');
    people.add(p);
    p = Person('Arthur Ford');
    p.transactions.add(Transaction(type: TransactionType.debt, amount: 7.8, description: 'Pens'));
    people.add(p);
    p = Person('Liam Mcmillan');
    p.transactions.add(Transaction(type: TransactionType.debt, amount: 4.99, description: 'Some debt'));
    p.transactions.add(Transaction(type: TransactionType.settleDebt, amount: 4.99, description: 'Some debt'));
    p.transactions.add(Transaction(type: TransactionType.credit, amount: 9.99, description: 'Some credit'));
    p.transactions.add(Transaction(type: TransactionType.settleCredit, amount: 9.99, description: 'Some credit'));
    people.add(p);
    p = Person('Maggie Nicholls');
    p.transactions.add(Transaction(type: TransactionType.debt, amount: 12, description: 'CDs'));
    people.add(p);
    sortPeople();
  }

  PBDataStore get protobuf {
    var store = PBDataStore();
    store.people.addAll(people.map((p) => p.protobuf));
    return store;
  }

  void save() async {
    if (kReleaseMode) {
      final file = await _localFile;
      file.writeAsBytes(protobuf.writeToBuffer());
      print('SAVED');
    }
  }

  void sortPeople() {
    people.sort((p1, p2) => p1.name.compareTo(p2.name));
  }
}


class Person {
  String id = Uuid().v4();
  String name;
  List<Transaction> transactions = [];
  bool reminderActive = false;
  DateTime reminderDate;

  Person(this.name);

  Person.fromPB(PBPerson p) {
    id = p.id;
    name = p.name;
    transactions = p.transactions.map((t) => Transaction.fromPB(t)).toList();
    reminderActive = p.reminderActive;
    reminderDate = DateTime.fromMillisecondsSinceEpoch(p.reminderTimestamp.toInt() * 1000);
  }

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
  String id = Uuid().v4();
  TransactionType type;
  double amount;
  String description;
  bool completed;
  DateTime date;

  Transaction({this.type, this.amount=0, this.description='', this.completed=false, this.date}) {
    if (type == null)
      type = TransactionType.credit;
    if (date == null)
      date = DateTime.now();
  }

  Transaction.fromPB(PBTransaction t) {
    id = t.id;
    type = TransactionType.fromPB(t.type);
    amount = t.amount;
    description = t.description;
    completed = t.completed;
    date = DateTime.fromMillisecondsSinceEpoch(t.timestamp.toInt() * 1000);
  }

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

  Text getAmountText(BuildContext context) {
    return Text(
      AppLocalizations.of(context).currencyFormatter.format(amount.abs()),
      style: Theme.of(context).textTheme.title.copyWith(color: type.color)
    );
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