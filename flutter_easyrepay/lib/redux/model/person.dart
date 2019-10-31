import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:fixnum/fixnum.dart';
import 'package:uuid/uuid.dart';


class Person {
  final String id;
  final String name;
  final bool reminderActive;
  final DateTime reminderDate;

  Person(this.id, this.name, this.reminderActive, this.reminderDate);

  factory Person.initial(String name) => 
    Person(Uuid().v4(), name, false, null);

  factory Person.fromPB(PBPerson pb) {
    // TODO: Import transactions
    return Person(pb.id,
           pb.name,
           pb.reminderActive,
           DateTime.fromMillisecondsSinceEpoch(pb.reminderTimestamp.toInt() * 1000));
  }

  PBPerson get protobuf {
    var p = PBPerson();
    p.id = id;
    p.name = name;
    //p.transactions.addAll(transactions.map((t) => t.protobuf));
    p.reminderActive = reminderActive;
    p.reminderTimestamp = reminderDate == null ? Int64(0) : Int64(reminderDate.millisecondsSinceEpoch ~/ 1000);
    return p;
  }

  Person copyWith({String name, bool reminderActive, DateTime reminderDate}) =>
    Person(this.id, name ?? this.name, reminderActive ?? this.reminderActive, reminderDate ?? this.reminderDate);

  bool operator ==(o) => o is Person && id == o.id;
  int get hashCode => id.hashCode;
}