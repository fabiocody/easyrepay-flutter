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
      body: _buildTransactionDetail()
    );
  }

  Widget _buildTransactionDetail() {
    final List<Widget> fields = [
      ListTile(
        leading: Icon(Icons.account_balance_wallet),
        title: Text("Type")
      ),
      ListTile(
        leading: Icon(Icons.attach_money),
        title: Text("Amount")
      ),
      ListTile(
        leading: Icon(Icons.label),
        title: Text("Note")
      ),
      ListTile(
        leading: Icon(Icons.check_circle_outline),
        title: Text("Completed")
      ),
      ListTile(
        leading: Icon(Icons.calendar_today),
        title: Text("Date")
      )
    ];
    /*final List<Widget> rows = ListTile.divideTiles(
      context: context,
      tiles: fields,
    ).toList();*/
    final List<Widget> rows = fields.map(
      (field) => Card(child: field,)
    ).toList();
    return ListView(
      padding: const EdgeInsets.all(16),
      children: rows
    );
  }

  /*Widget _buildTransactionDetailOld() {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                labelText: "Resevior Name",
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.green, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            )
          ],
        ),
      )
    );
  }*/

}