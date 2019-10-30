import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:fixnum/fixnum.dart';
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
    Person(p.id, p.name, p.transactions.map((t) => Transaction.from(t)), p.reminderActive, p.reminderDate);

  /*factory Person.fromPB(PBPerson pb) =>
    Person(pb.id, pb.name, pb.transactions.map())*/

  PBPerson get protobuf {
    var p = PBPerson();
    p.id = id;
    p.name = name;
    p.transactions.addAll(transactions.map((t) => t.protobuf).toList());
    p.reminderActive = reminderActive;
    p.reminderTimestamp = reminderDate == null ? Int64(0) : Int64(reminderDate.millisecondsSinceEpoch ~/ 1000);
    return p;
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

  factory Transaction.initial({type=TransactionType.credit, amount=0, description='', completed=false, date}) => 
    Transaction(Uuid().v4(), type, amount, description, completed, date == null ? DateTime.now() : date);

  factory Transaction.from(Transaction t) =>
    Transaction(t.id, t.type, t.amount, t.description, t.completed, t.date);

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
    t.description = description;
    t.completed = completed;
    t.timestamp = Int64(date.millisecondsSinceEpoch ~/ 1000);
    return t;
  }
}


enum TransactionType { credit, debt, settleCredit, settleDebt }