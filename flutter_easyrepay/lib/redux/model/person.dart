import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:easyrepay/redux/model/app_state.dart';
import 'package:easyrepay/redux/model/transaction.dart';
import 'package:easyrepay/redux/model/transaction_type.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
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

  Person copyWith({String name, bool reminderActive, DateTime reminderDate}) {
    return Person(id, name ?? this.name, reminderActive ?? this.reminderActive, reminderDate ?? this.reminderDate);
  }
}