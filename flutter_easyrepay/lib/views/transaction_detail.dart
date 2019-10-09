import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:flutter/material.dart';


class TransactionDetail extends StatefulWidget {
  final PBTransaction transaction;
  TransactionDetail(this.transaction);
  State createState() => _TransactionDetailState();
}


class _TransactionDetailState extends State<TransactionDetail> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TextEditingController _amountController = TextEditingController();
  TextEditingController _noteController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction")
      ),
      body: _buildTransactionDetail()
    );
  }

  Widget _buildTransactionDetail() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.account_balance_wallet),
              labelText: "Type",
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.attach_money),
              labelText: "Amount",
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.label),
              labelText: "Note",
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.check_circle_outline),
              labelText: "Completed",
            ),
          ),
          TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.calendar_today),
              labelText: "Date",
            ),
          ),
        ],
      ),
    );
  }

}