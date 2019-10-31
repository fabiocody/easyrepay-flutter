import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:easyrepay/redux/model/person.dart';
import 'package:easyrepay/redux/model/transaction.dart';
import 'package:easyrepay/redux/model/transaction_type.dart';
import 'package:flutter/material.dart';


class AppState {
  final List<Person> people;
  final List<Transaction> transactions;
  final bool showCompleted;

  AppState(people, transactions, this.showCompleted):
    this.people = List.unmodifiable(List.from(people)),
    this.transactions = List.unmodifiable(List.from(transactions));

  factory AppState.initial() => AppState([], [], false);

  factory AppState.debug() {
    var ppl = [];
    /*Person p;
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
    ppl.sort((p1, p2) => p1.name.compareTo(p2.name));*/
    return AppState(ppl, [], false);
  }

  /*factory AppState.fromPB(PBDataStore pb) {
    return AppState(pb.people.map((p) => Person.fromPB(p)).toList(), false);
  }*/

  AppState copyWith({List<Person> people, List<Transaction> transactions, bool showCompleted}) {
    var ppl = people == null ? this.people : people;
    var tt = transactions == null ? this.transactions : transactions;
    return AppState(ppl, tt, showCompleted ?? this.showCompleted);
  }

  /*PBDataStore get protobuf {
    var store = PBDataStore();
    store.people.addAll(people.map((p) => p.protobuf));
    return store;
  }*/

  List<Transaction> getTransactionsOf(Person p) => transactions
    .where((t) => t.personID == p.id)
    .toList();

  int getTransactionCountOf(Person p) => transactions
    .where((t) => t.personID == p.id)
    .where((t) => !t.completed)
    .length;

  double _sumFold(double value, Transaction t) =>
    t.type.addOrSub(value, t.amount);

  Text getTotalAmountTextTile(Person p, BuildContext context) {
    var amount = getTransactionsOf(p)
      .where((t) => !t.completed)
      .fold(0.0, _sumFold);
    return Text(
      AppLocalizations.of(context).currencyFormatter.format(amount.abs()),
      style: Theme.of(context).textTheme.title.copyWith(
        color: amount.isNegative ? DarkColors.orange : DarkColors.lightGreen
      )
    );
  }

  Text getCreditAmountText(Person p, BuildContext context) {
    var amount = getTransactionsOf(p)
      .where((t) => !t.completed && (t.type == TransactionType.credit || t.type == TransactionType.settleDebt))
      .fold(0.0, _sumFold);
    return Text(
      AppLocalizations.of(context).currencyFormatter.format(amount.abs()),
      style: Theme.of(context).textTheme.display1.copyWith(color: DarkColors.lightGreen)
    );
  }

  Text getDebtAmountText(Person p, BuildContext context) {
    var amount = getTransactionsOf(p)
      .where((t) => !t.completed && (t.type == TransactionType.debt || t.type == TransactionType.settleCredit))
      .fold(0.0, _sumFold);
    return Text(
      AppLocalizations.of(context).currencyFormatter.format(amount.abs()),
      style: Theme.of(context).textTheme.display1.copyWith(color: DarkColors.orange)
    );
  }

  Text getTotalAmountText(Person p, BuildContext context) {
    var amount = getTransactionsOf(p)
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