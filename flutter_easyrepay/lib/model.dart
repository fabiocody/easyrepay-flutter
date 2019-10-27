import 'dart:io';
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
    p.transactions.add(Transaction(type: TransactionType.debt, amount: 4.5, note: 'Pizza'));
    p.transactions.add(Transaction(type: TransactionType.credit, amount: 15, note: 'Pocket money'));
    p.transactions.add(Transaction(type: TransactionType.credit, amount: 7, note: 'Lunch', completed: true));
    people.add(p);
    p = Person('Steve Wilkins');
    people.add(p);
    p = Person('Arthur Ford');
    p.transactions.add(Transaction(type: TransactionType.debt, amount: 7.8, note: 'Pens'));
    people.add(p);
    p = Person('Liam Mcmillan');
    p.transactions.add(Transaction(type: TransactionType.debt, amount: 4.99, note: 'Some debt'));
    p.transactions.add(Transaction(type: TransactionType.settleDebt, amount: 4.99, note: 'Some debt'));
    p.transactions.add(Transaction(type: TransactionType.credit, amount: 9.99, note: 'Some credit'));
    p.transactions.add(Transaction(type: TransactionType.settleCredit, amount: 9.99, note: 'Some credit'));
    people.add(p);
    p = Person('Maggie Nicholls');
    p.transactions.add(Transaction(type: TransactionType.debt, amount: 12, note: 'CDs'));
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

  int get transactions_count {
    return transactions.where((t) => !t.completed).length;
  }

  void sortTransactions() {
    transactions.sort((t1, t2) => t1.date.compareTo(t2.date));
  }

  double _sumFold(double value, Transaction t) {
    switch(t.type) {
      case TransactionType.credit:
      case TransactionType.settleDebt:
        return value + t.amount;
      case TransactionType.debt:
      case TransactionType.settleCredit:
        return value - t.amount;
      default:
        return value;
    }
  }

  Text getTotalAmountTextTile(BuildContext context) {
    var amount = transactions
      .where((t) => !t.completed)
      .fold(0.0, _sumFold);
    return Text(
      currencyFormatter.format(amount.abs()),
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
      currencyFormatter.format(amount.abs()),
      style: Theme.of(context).textTheme.display1.copyWith(color: DarkColors.lightGreen)
    );
  }

  Text getDebtAmountText(BuildContext context) {
    var amount = transactions
      .where((t) => !t.completed && (t.type == TransactionType.debt || t.type == TransactionType.settleCredit))
      .fold(0.0, _sumFold);
    return Text(
      currencyFormatter.format(amount.abs()),
      style: Theme.of(context).textTheme.display1.copyWith(color: DarkColors.orange)
    );
  }

  Text getTotalAmountText(BuildContext context) {
    var amount = transactions
      .where((t) => !t.completed)
      .fold(0.0, _sumFold);
    return Text(
      currencyFormatter.format(amount.abs()),
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
  String note;
  bool completed;
  DateTime date;

  Transaction({this.type=TransactionType.credit, this.amount=0, this.note='', this.completed=false, this.date}) {
    if (date == null)
      date = DateTime.now();
  }

  Transaction.fromPB(PBTransaction t) {
    id = t.id;
    type = () {
      switch (t.type) {
        case PBTransactionType.CREDIT:
          return TransactionType.credit;
        case PBTransactionType.DEBT:
          return TransactionType.debt;
        case PBTransactionType.SETTLE_CREDIT:
          return TransactionType.settleCredit;
        case PBTransactionType.SETTLE_DEBT:
          return TransactionType.settleDebt;
        default:
          return null;
      }
    }();
    amount = t.amount;
    note = t.note;
    completed = t.completed;
    date = DateTime.fromMillisecondsSinceEpoch(t.timestamp.toInt() * 1000);
  }

  PBTransaction get protobuf {
    var t = PBTransaction();
    t.id = id;
    t.type = () {
      switch (type) {
        case TransactionType.credit:
          return PBTransactionType.CREDIT;
        case TransactionType.debt:
          return PBTransactionType.DEBT;
        case TransactionType.settleCredit:
          return PBTransactionType.SETTLE_CREDIT;
        case TransactionType.settleDebt:
          return PBTransactionType.SETTLE_DEBT;
        default:
          return null;
      }
    }();
    t.amount = amount;
    t.note = note;
    t.completed = completed;
    t.timestamp = Int64(date.millisecondsSinceEpoch ~/ 1000);
    return t;
  }

  Text getAmountText(BuildContext context) {
    return Text(
      currencyFormatter.format(amount.abs()),
      style: Theme.of(context).textTheme.title.copyWith(
        color: () {
          switch (type) {
            case TransactionType.credit:
              return DarkColors.lightGreen;
            case TransactionType.settleDebt:
              return DarkColors.magenta;
            case TransactionType.debt:
              return DarkColors.orange;
            case TransactionType.settleCredit:
              return DarkColors.teal;
            default:
              return DarkColors.darkGrey;
          }
        }(),
      )
    );
  }
}


enum TransactionType { credit, debt, settleCredit, settleDebt }
