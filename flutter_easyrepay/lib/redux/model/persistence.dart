import 'dart:typed_data';
import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:easyrepay/redux/model/app_state.dart';
import 'package:easyrepay/redux/model/person.dart';
import 'package:easyrepay/redux/model/transaction.dart';
import 'package:easyrepay/redux/model/transaction_type.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/foundation.dart';
import 'package:redux_persist/redux_persist.dart';


class ProtobufSerializer implements StateSerializer<AppState> {
  AppState decode(Uint8List data) {
    if (data== null) return AppState.initial();
    final pbStore = PBDataStore.fromBuffer(data);
    var ppl = [];
    var tt = [];
    for (PBPerson p in pbStore.people) {
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
    debugPrint('Loaded state from persistent store.');
    return AppState(ppl, tt, null);
  }

  Uint8List encode(AppState state) {
    if (state == null) return null;
    var store = PBDataStore();
    for (Person p in state.people) {
      PBPerson pb = PBPerson();
      pb.id = p.id;
      pb.name = p.name;
      pb.reminderActive = p.reminderActive;
      if (p.reminderDate != null) pb.reminderTimestamp = Int64(p.reminderDate.millisecondsSinceEpoch ~/ 1000);
      store.people.add(pb);
    }
    for (Transaction t in state.transactions) {
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
    debugPrint('Saved state to persistent store.');
    return store.writeToBuffer();
  }
}