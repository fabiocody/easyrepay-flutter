import 'package:fixnum/fixnum.dart';
import 'package:uuid/uuid.dart';

import 'package:easyrepay/proto/easyrepay.pb.dart';


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
    p = ModelFactory.newPerson(name: "Maggie Nicholls");
    p.transactions.add(ModelFactory.newTransaction(type: PBTransactionType.DEBT, amount: 4.5, note: "Pizza"));
    p.transactions.add(ModelFactory.newTransaction(type: PBTransactionType.CREDIT, amount: 15, note: "Pocket money"));
    p.transactions.add(ModelFactory.newTransaction(type: PBTransactionType.CREDIT, amount: 7, note: "Lunch", completed: true));
    store.people.add(p);
    // Second person
    p = ModelFactory.newPerson(name: "Christos Soto");
    store.people.add(p);
    // Third person
    p = ModelFactory.newPerson(name: "Robyn Key");
    p.transactions.add(ModelFactory.newTransaction(type: PBTransactionType.DEBT, amount: 7.8, note: "Pens"));
    store.people.add(p);
    store.people.sort((p1, p2) => p1.name.compareTo(p2.name));
  }

  static PBPerson newPerson({String name}) {
    var p = PBPerson();
    p.id = Uuid().v4();
    if (name != null) p.name = name;
    else p.name = "New person";
    p.reminderActive = false;
    return p;
  }

  static PBTransaction newTransaction({PBTransactionType type = PBTransactionType.CREDIT, double amount = 0, String note, DateTime date, bool completed = false}) {
    var t = PBTransaction();
    t.id = Uuid().v4();
    t.type = type;
    t.amount = amount;
    if (note == null) t.note = "New transaction";
    else t.note = note;
    t.completed = completed;
    if (date == null) t.timestamp = Int64(DateTime.now().millisecondsSinceEpoch ~/ 1000);
    else t.timestamp = Int64(date.millisecondsSinceEpoch ~/ 1000);
    return t;
  }

}