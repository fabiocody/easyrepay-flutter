import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:easyrepay/redux/model/person.dart';
import 'package:easyrepay/redux/model/transaction.dart';
import 'package:easyrepay/redux/model/transaction_type.dart';


class AppState {
  final List<Person> people;
  final bool showCompleted;

  AppState(people, this.showCompleted):
    this.people = List.unmodifiable(List.from(people));

  factory AppState.initial() => AppState([], false);

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
    return AppState(ppl, false);
  }

  factory AppState.fromPB(PBDataStore pb) {
    return AppState(pb.people.map((p) => Person.fromPB(p)).toList(), false);
  }

  AppState copyWith({List<Person> people, bool showCompleted}) {
    var ppl = people == null ? this.people : people;
    ppl = ppl.map((p) => p.clone()).toList();
    return AppState(ppl, showCompleted ?? this.showCompleted);
  }

  PBDataStore get protobuf {
    var store = PBDataStore();
    store.people.addAll(people.map((p) => p.protobuf));
    return store;
  }
}