import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class TransactionDetail extends StatefulWidget {
  final Transaction transaction;
  TransactionDetail(this.transaction);
  State createState() => _TransactionDetailState();
}


class _TransactionDetailState extends State<TransactionDetail> {

  TransactionType _type;
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
    _date = widget.transaction.date;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            tooltip: 'Save',
            onPressed: _save,
          )
        ],
      ),
      body: _buildTransactionDetail(context)
    );
  }

  Widget _buildTransactionDetail(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: <Widget>[
        InputDecorator(
          decoration: InputDecoration(
            icon: const Icon(Icons.account_balance_wallet),
            labelText: 'Type'
          ),
          isEmpty: _type == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              value: _type,
              isDense: true,
              onChanged: (TransactionType newValue) {
                setState(() {
                  _type = newValue;
                });
              },
              items: TransactionType.values.map((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Text(() {
                    switch (value) {
                      case TransactionType.credit:
                        return 'Credit';
                      case TransactionType.debt:
                        return 'Debt';
                      case TransactionType.settleCredit:
                        return 'Settle credit';
                      case TransactionType.settleDebt:
                        return 'Settle debt';
                      default:
                        return '';
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
            labelText: 'Amount',
            hintText: 'Enter the amount'
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
            labelText: 'Note',
            hintText: 'Enter the note'
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
              Text(
                'Completed',
                style: Theme.of(context).textTheme.subhead,
              ),
              Switch(
                value: _completed,
                onChanged: (newValue) {
                  setState(() {
                    _completed = newValue;
                  });
                },
              )
            ],
          ),
        ),
        InkWell(
          child: InputDecorator(
            decoration: InputDecoration(
              icon: const Icon(Icons.calendar_today),
              labelText: 'Date',
            ),
            child: Text(
              dateFormatter.format(_date),
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          onTap: () => _showDateTimePicker(context),
        ),
      ],
    );
  }

  void _save() {
    setState(() {
      widget.transaction.type = _type;
      widget.transaction.amount = double.tryParse(_amountController.text);
      widget.transaction.note = _noteController.text;
      widget.transaction.completed = _completed;
      widget.transaction.date = _date;
    });
    DataStore.shared().save();
    Navigator.of(context).pop();
  }

  void _showDateTimePicker(BuildContext context) async {
    var date = await showDatePicker(
      initialDate: _date,
      firstDate: _date.subtract(Duration(days: 365)),
      lastDate: _date.add(Duration(days: 365)),
      context: context,
    );
    var time = await showTimePicker(
      initialTime: TimeOfDay.fromDateTime(_date),
      context: context,
    );
    setState(() => _date = DateTime(date.year, date.month, date.day, time.hour, time.minute));
  }
}