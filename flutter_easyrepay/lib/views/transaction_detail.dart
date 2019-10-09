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

  void initState() {
    super.initState();
    _amountController.text = widget.transaction.amount.toString();
    _noteController.text = widget.transaction.note;
  }

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
      autovalidate: true,
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          FormField(
            builder: (FormFieldState state) {
              return InputDecorator(
                decoration: InputDecoration(
                  icon: const Icon(Icons.account_balance_wallet),
                  labelText: "Type"
                ),
                isEmpty: widget.transaction.type == null,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: widget.transaction.type,
                    isDense: true,
                    onChanged: (PBTransactionType newValue) {
                      setState(() {
                        widget.transaction.type = newValue;
                      });
                    },
                    items: PBTransactionType.values.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text(value.toString())
                      );
                    }).toList(),
                  )
                )
              );
            },
          ),
          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(
              icon: const Icon(Icons.attach_money),
              labelText: "Amount",
              hintText: "Enter the amount"
            ),
          ),
          TextFormField(
            controller: _noteController,
            decoration: const InputDecoration(
              icon: const Icon(Icons.label),
              labelText: "Note",
              hintText: "Enter the note"
            ),
          ),
          FormField(
            builder: (FormFieldState state) {
              return InputDecorator(
                decoration: InputDecoration(
                  icon: const Icon(Icons.check_circle_outline),
                  labelText: "Completed"
                ),
                //isEmpty: true,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    value: widget.transaction.completed,
                    isDense: true,
                    onChanged: (bool value) {
                      setState(() {
                        widget.transaction.completed = value;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: true,
                        child: const Text("Yes")
                      ),
                      DropdownMenuItem(
                        value: false,
                        child: const Text("No")
                      )
                    ],
                    /*items: PBTransactionType.values.map((value) {
                      return DropdownMenuItem(
                        value: value,
                        child: Text("$value")
                      );
                    }).toList(),*/
                  )
                )
              );
            },
          ),
          /*TextFormField(
            decoration: const InputDecoration(
              icon: const Icon(Icons.check_circle_outline),
              labelText: "Completed",
            ),
          ),*/
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