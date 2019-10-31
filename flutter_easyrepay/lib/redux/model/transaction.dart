import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:easyrepay/redux/model/transaction_type.dart';
import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';


class Transaction {
  final String id;
  final String personID;
  final TransactionType type;
  final double amount;
  final String description;
  final bool completed;
  final DateTime date;

  Transaction(this.id, this.personID, this.type, this.amount, this.description, this.completed, this.date);

  factory Transaction.initial({type, amount=0, description='', completed=false, date}) => 
    Transaction(Uuid().v4(), 
                Uuid().v4(),
                type == null ? TransactionType.credit : type, 
                amount, 
                description, 
                completed, 
                date ?? DateTime.now());

 Transaction clone() =>
    Transaction(id, personID, type, amount, description, completed, date);

  /*factory Transaction.fromPB(PBTransaction pb) =>
    Transaction(pb.id,
                TransactionType.fromPB(pb.type),
                pb.amount,
                pb.description,
                pb.completed,
                DateTime.fromMillisecondsSinceEpoch(pb.timestamp.toInt() * 1000));*/

  /*PBTransaction get protobuf {
    var t = PBTransaction();
    t.id = id;
    t.type = type.protobuf;
    t.amount = amount;
    t.description = description;
    t.completed = completed;
    t.timestamp = Int64(date.millisecondsSinceEpoch ~/ 1000);
    return t;
  }*/

  Text getAmountText(BuildContext context) {
    return Text(
      AppLocalizations.of(context).currencyFormatter.format(amount.abs()),
      style: Theme.of(context).textTheme.title.copyWith(
        color: type.color,
      )
    );
  }
}