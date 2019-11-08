import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/redux/model/person.dart';
import 'package:easyrepay/redux/model/transaction.dart';
import 'package:easyrepay/redux/model/transaction_type.dart';
import 'package:easyrepay/views/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class AppState {
  final List<Person> people;
  final List<Transaction> transactions;
  final AppState prevState;

  AppState(people, transactions, this.prevState):
      this.people = List.unmodifiable(people),
      this.transactions = List.unmodifiable(transactions);

  factory AppState.initial() => kReleaseMode ? AppState([], [], null) : AppState._debug();

  factory AppState._debug() {
    List<Person> ppl = [];
    List<Transaction> tt = [];
    Person p = Person.initial('Brooklyn Thompson');
    tt.add(Transaction.initial(personID: p.id, type: TransactionType.debt, amount: 4.5, description: 'Pizza'));
    tt.add(Transaction.initial(personID: p.id, type: TransactionType.credit, amount: 15, description: 'Pocket money'));
    tt.add(Transaction.initial(personID: p.id, type: TransactionType.credit, amount: 7, description: 'Lunch', completed: true));
    ppl.add(p);
    p = Person.initial('Steve Wilkins');
    ppl.add(p);
    p = Person.initial('Arthur Ford');
    tt.add(Transaction.initial(personID: p.id, type: TransactionType.debt, amount: 7.8, description: 'Pens'));
    ppl.add(p);
    p = Person.initial('Liam Mcmillan');
    tt.add(Transaction.initial(personID: p.id, type: TransactionType.debt, amount: 4.99, description: 'Some debt'));
    tt.add(Transaction.initial(personID: p.id, type: TransactionType.settleDebt, amount: 4.99, description: 'Some debt'));
    tt.add(Transaction.initial(personID: p.id, type: TransactionType.credit, amount: 9.99, description: 'Some credit'));
    tt.add(Transaction.initial(personID: p.id, type: TransactionType.settleCredit, amount: 9.99, description: 'Some credit'));
    ppl.add(p);
    p = Person.initial('Maggie Nicholls');
    tt.add(Transaction.initial(personID: p.id, type: TransactionType.debt, amount: 12, description: 'CDs'));
    ppl.add(p);
    ppl.sort((p1, p2) => p1.name.compareTo(p2.name));
    tt.sort((t1, t2) => t1.date.compareTo(t2.date));
    return AppState(ppl, tt, null);
  }

  AppState copyWith({List<Person> people, List<Transaction> transactions, bool showCompleted, bool needSave=true}) {
    return AppState(people ?? this.people, transactions ?? this.transactions, this);
  }

  bool get canUndo => prevState != null;

  List<Transaction> getTransactionsOf(Person p) => transactions
    .where((t) => t.personID == p.id && !t.completed)
    .toList();

  List<Transaction> getCompletedTransactionsOf(Person p) => transactions
    .where((t) => t.personID == p.id && t.completed)
    .toList();

  int getTransactionCountOf(Person p) => getTransactionsOf(p).length;

  int getCompletedTransactionsCountOf(Person p) => getCompletedTransactionsOf(p).length;

  double _sumFold(double value, Transaction t) =>
    t.type.addOrSub(value, t.amount);

  Text getTotalAmountTextTile(Person p, BuildContext context) {
    var amount = getTransactionsOf(p)
      .where((t) => !t.completed)
      .fold(0.0, _sumFold);
    return Text(
      AppLocalizations.of(context).currencyFormatter.format(amount.abs()),
      style: Theme.of(context).textTheme.title.copyWith(
        color: amount.isNegative ? DarkColors.orange : DarkColors.lightGreen,
        fontFamily: 'RobotoSlab'
      )
    );
  }

  Text getCreditAmountText(Person p, BuildContext context) {
    var amount = getTransactionsOf(p)
      .where((t) => !t.completed && (t.type == TransactionType.credit || t.type == TransactionType.settleDebt))
      .fold(0.0, _sumFold);
    return Text(
      AppLocalizations.of(context).currencyFormatter.format(amount.abs()),
      style: Theme.of(context).textTheme.headline.copyWith(
        color: DarkColors.lightGreen,
        fontFamily: 'RobotoSlab'
      )
    );
  }

  Text getDebtAmountText(Person p, BuildContext context) {
    var amount = getTransactionsOf(p)
      .where((t) => !t.completed && (t.type == TransactionType.debt || t.type == TransactionType.settleCredit))
      .fold(0.0, _sumFold);
    return Text(
      AppLocalizations.of(context).currencyFormatter.format(amount.abs()),
      style: Theme.of(context).textTheme.headline.copyWith(
        color: DarkColors.orange,
        fontFamily: 'RobotoSlab'
      )
    );
  }

  Text getTotalAmountText(Person p, BuildContext context) {
    var amount = getTransactionsOf(p)
      .where((t) => !t.completed)
      .fold(0.0, _sumFold);
    return Text(
      AppLocalizations.of(context).currencyFormatter.format(amount.abs()),
      style: Theme.of(context).textTheme.headline.copyWith(
        color: amount.isNegative ? DarkColors.orange : DarkColors.lightGreen,
        fontFamily: 'RobotoSlab'
      )
    );
  }
}