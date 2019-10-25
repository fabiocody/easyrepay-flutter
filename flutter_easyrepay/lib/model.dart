import 'package:easyrepay/helpers.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class DataStore {
  List<Person> people = [];

  static DataStore _store;

  static DataStore shared() {
    if (_store == null)
      _store = DataStore();
    return _store;
  }

  void fillWithLocalData() {
    // TODO
  }

  void fillWithDebugData() {
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
