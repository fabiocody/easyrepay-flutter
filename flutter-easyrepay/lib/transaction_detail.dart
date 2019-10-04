import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:flutter/material.dart';

class TransactionDetail extends StatefulWidget {
  final PBTransaction transaction;
  TransactionDetail(this.transaction);
  State createState() => _TransactionDetailState();
}


class _TransactionDetailState extends State<TransactionDetail> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction")
      ),
      body: Center(
        child: Text("Hello, world!", textScaleFactor: 3)
      )
    );
  }

}