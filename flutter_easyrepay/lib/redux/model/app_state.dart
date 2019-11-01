import 'dart:io';
import 'package:easyrepay/app_localizations.dart';
import 'package:fixnum/fixnum.dart';
import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:easyrepay/redux/model/person.dart';
import 'package:easyrepay/redux/model/transaction.dart';
import 'package:easyrepay/redux/model/transaction_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class AppState {
  static final isRelease = !kReleaseMode;
  final List<Person> people;
  final List<Transaction> transactions;
  final bool showCompleted;
  final bool isLoading;

  AppState(people, transactions, this.showCompleted, this.isLoading, {bool needsSave=true}):
      this.people = List.unmodifiable(people),
      this.transactions = List.unmodifiable(transactions) {
    if (needsSave) save();
  }

  factory AppState.initial() => AppState([], [], false, false, needsSave: false);

  factory AppState.debug() {
    var ppl = [];
    var tt = [];
    var p = Person.initial('Brooklyn Thompson');
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
    return AppState(ppl, tt, false, false, needsSave: false);
  }

  factory AppState.fromPB(PBDataStore pb) {
    var ppl = [];
    var tt = [];
    for (PBPerson p in pb.people) {
      ppl.add(Person(p.id,
                     p.name,
                     p.reminderActive,
                     DateTime.fromMillisecondsSinceEpoch(p.reminderTimestamp.toInt() * 1000)));
      for (PBTransaction t in p.transactions) {
        tt.add(Transaction(t.id,
                           p.id,
                           TransactionType.fromPB(t.type),
                           t.amount,
                           t.description,
                           t.completed,
                           DateTime.fromMillisecondsSinceEpoch(t.timestamp.toInt() * 1000)));
      }
    }
    return AppState(ppl, tt, false, false);
  }

  AppState copyWith({List<Person> people, List<Transaction> transactions, bool showCompleted, bool isLoading, bool save=true}) {
    var ppl = people == null ? this.people : people;
    var tt = transactions == null ? this.transactions : transactions;
    return AppState(ppl, tt, showCompleted ?? this.showCompleted, isLoading ?? this.isLoading, needsSave: save);
  }

  PBDataStore get protobuf {
    var store = PBDataStore();
    for (Person p in people) {
      PBPerson pb = PBPerson();
      pb.id = p.id;
      pb.name = p.name;
      pb.reminderActive = p.reminderActive;
      if (p.reminderDate != null) pb.reminderTimestamp = Int64(p.reminderDate.millisecondsSinceEpoch ~/ 1000);
      store.people.add(pb);
    }
    for (Transaction t in transactions) {
      PBTransaction pb = PBTransaction();
      pb.id = t.id;
      pb.type = t.type.protobuf;
      pb.amount = t.amount;
      pb.description = t.description;
      pb.completed = t.completed;
      pb.timestamp = Int64(t.date.millisecondsSinceEpoch ~/ 1000);
      PBPerson pbPerson = store.people.firstWhere((p) => p.id == t.personID);
      pbPerson?.transactions?.add(pb);
    }
    return store;
  }

  static Future<AppState> load() async =>
    isRelease ? _loadLocal() : Future<AppState>.value(AppState.debug());

  void save() async {
    if (isRelease) _saveLocal();
  }

  static Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return File('$path/easyrepay_datastore.pb');
  }

  static Future<AppState> _loadLocal() async {
    try {
      final file = await _localFile;
      final bytes = await file.readAsBytes();
      final pbStore = PBDataStore.fromBuffer(bytes);
      return AppState.fromPB(pbStore);
    } catch (e) {
      print(e);
      return AppState.initial();
    }
  }

  void _saveLocal() async {
    final file = await _localFile;
    file.writeAsBytes(protobuf.writeToBuffer());
    print('SAVED');
  }

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