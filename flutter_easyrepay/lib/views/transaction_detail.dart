import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class TransactionDetail extends StatefulWidget {
  final PBTransaction transaction;
  TransactionDetail(this.transaction);
  State createState() => _TransactionDetailState();
}


class _TransactionDetailState extends State<TransactionDetail> {

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  PBTransactionType _type;
  TextEditingController _amountController = TextEditingController();
  TextEditingController _noteController = TextEditingController();
  bool _completed;
  DateTime _date;

  void initState() {
    super.initState();
    _type = widget.transaction.type;
    _amountController.text = amountTextFieldFormatter.format(widget.transaction.amount);
    _noteController.text = widget.transaction.note;
    _completed = widget.transaction.completed;
    _date = DateTime.fromMillisecondsSinceEpoch(widget.transaction.timestamp.toInt() * 100);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            tooltip: "Save",
            onPressed: _save,
          )
        ],
      ),
      body: _buildTransactionDetail()
    );
  }

  Widget _buildTransactionDetail() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: <Widget>[
        InputDecorator(
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
                  child: Text(() {
                    switch (value) {
                      case PBTransactionType.CREDIT:
                        return "Credit";
                      case PBTransactionType.DEBT:
                        return "Debt";
                      case PBTransactionType.SETTLE_CREDIT:
                        return "Settle credit";
                      case PBTransactionType.SETTLE_DEBT:
                        return "Settle debt";
                      default:
                        return "";
                    }
                  }())
                );
              }).toList(),
            )
          )
        ),
        TextFormField(
          controller: _amountController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.attach_money),
            labelText: "Amount",
            hintText: "Enter the amount"
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly
          ],
          onChanged: (String text) {
            var value = double.tryParse(text);
            if (value != null) {
              value /= 100;
              _amountController.text = amountTextFieldFormatter.format(value);
            }
          },
        ),
        TextFormField(
          controller: _noteController,
          decoration: const InputDecoration(
            icon: const Icon(Icons.label),
            labelText: "Note",
            hintText: "Enter the note"
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        InputDecorator(
          decoration: InputDecoration(
            icon: const Icon(Icons.check_circle_outline),
            contentPadding: const EdgeInsets.symmetric(vertical: 6)
          ),
          //isEmpty: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Completed", textScaleFactor: 1.1,),
              Switch(
                value: _completed,
                onChanged: (newValue) {
                  setState(() {
                    _completed = newValue;
                  });
                },
                activeColor: Colors.green,
              )
            ],
          ),
        ),
        TextFormField(
          decoration: const InputDecoration(
            icon: const Icon(Icons.calendar_today),
            labelText: "Date",
          ),
        ),
      ],
    );
  }

  void _save() {
    var t = widget.transaction;
    t.type = _type;
    t.amount = double.tryParse(_amountController.text);
    t.note = _noteController.text;
    t.completed = _completed;
    // TODO: date
    Navigator.of(context).pop();
  }

}