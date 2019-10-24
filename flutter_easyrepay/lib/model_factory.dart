import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ModelFactory {

  static PBDataStore _store;

  static PBDataStore getStore() {
    if (_store == null) {
      _store = PBDataStore();
    }
    return _store;
  }

  static void getDebugData(PBDataStore store) {
    store.clear();
    PBPerson p;
    // First person
    p = ModelFactory.newPerson(name: 'Brooklyn Thompson');
    p.transactions.add(ModelFactory.newTransaction(type: PBTransactionType.DEBT, amount: 4.5, note: 'Pizza'));
    p.transactions.add(ModelFactory.newTransaction(type: PBTransactionType.CREDIT, amount: 15, note: 'Pocket money'));
    p.transactions.add(ModelFactory.newTransaction(type: PBTransactionType.CREDIT, amount: 7, note: 'Lunch', completed: true));
    store.people.add(p);
    // Second person
    p = ModelFactory.newPerson(name: 'Steve Wilkins');
    store.people.add(p);
    // Third person
    p = ModelFactory.newPerson(name: 'Arthur Ford');
    p.transactions.add(ModelFactory.newTransaction(type: PBTransactionType.DEBT, amount: 7.8, note: 'Pens'));
    store.people.add(p);
    p = ModelFactory.newPerson(name: 'Liam Mcmillan');
    p.transactions.add(ModelFactory.newTransaction(type: PBTransactionType.DEBT, amount: 4.99, note: 'Some debt'));
    p.transactions.add(ModelFactory.newTransaction(type: PBTransactionType.SETTLE_DEBT, amount: 4.99, note: 'Some debt'));
    p.transactions.add(ModelFactory.newTransaction(type: PBTransactionType.CREDIT, amount: 9.99, note: 'Some credit'));
    p.transactions.add(ModelFactory.newTransaction(type: PBTransactionType.SETTLE_CREDIT, amount: 9.99, note: 'Some credit'));
    store.people.add(p);
    p = ModelFactory.newPerson(name: 'Maggie Nicholls');
    p.transactions.add(ModelFactory.newTransaction(type: PBTransactionType.DEBT, amount: 12, note: 'CDs'));
    store.people.add(p);
    sortPeople();
    store.settings = PBSettings();
  }

  static PBPerson newPerson({String name}) {
    var p = PBPerson();
    p.id = Uuid().v4();
    if (name != null) p.name = name;
    else p.name = 'New person';
    p.reminderActive = false;
    return p;
  }

  static PBTransaction newTransaction({PBTransactionType type = PBTransactionType.CREDIT, double amount = 0, String note = '', DateTime date, bool completed = false}) {
    var t = PBTransaction();
    t.id = Uuid().v4();
    t.type = type;
    t.amount = amount;
    t.note = note;
    t.completed = completed;
    if (date == null) t.timestamp = Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000);
    else t.timestamp = Int64(date.millisecondsSinceEpoch ~/ 1000);
    return t;
  }

  static void sortPeople() {
    getStore().people.sort((p1, p2) => p1.name.compareTo(p2.name));
  }

  static double _getTotalAmount(PBPerson p) {
    return p.transactions
      .where((transaction) => !transaction.completed)
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

  static Text getTotalAmountText(PBPerson p, BuildContext context) {
    var amount = _getTotalAmount(p);
    return Text(
      currencyFormatter.format(amount.abs()),
      style: Theme.of(context).textTheme.title.copyWith(
        color: amount.isNegative ? DarkColors.orange : DarkColors.lightGreen,
      )
    );
  }

  static Text getAmountText(PBTransaction t, BuildContext context) {
    return Text(
      currencyFormatter.format(t.amount.abs()),
      style: Theme.of(context).textTheme.title.copyWith(
        color: () {
          switch (t.type) {
            case PBTransactionType.CREDIT:
              return DarkColors.lightGreen;
            case PBTransactionType.SETTLE_DEBT:
              return DarkColors.magenta;
            case PBTransactionType.DEBT:
              return DarkColors.orange;
            case PBTransactionType.SETTLE_CREDIT:
              return DarkColors.teal;
            default:
              return DarkColors.darkGrey;
          }
        }(),
      )
    );
  }

}