import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/redux/actions.dart';
import 'package:easyrepay/redux/model/app_state.dart';
import 'package:easyrepay/redux/model/person.dart';
import 'package:easyrepay/redux/model/transaction.dart';
import 'package:easyrepay/redux/model/transaction_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';


class TransactionDetail extends StatefulWidget {
  final Store<AppState> store;
  final Transaction transaction;
  final Person person;
  TransactionDetail(this.store, this.person, this.transaction);
  State createState() => _TransactionDetailState();
}


class _TransactionDetailState extends State<TransactionDetail> {

  TransactionType _type;
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  DateTime _date;
  bool _initialized = false;

  void initState() {
    super.initState();
    _type = widget.transaction.type;
    _descriptionController.text = widget.transaction.description;
    _date = widget.transaction.date;
  }

  Widget build(BuildContext context) {
    if (!_initialized) {
      _amountController.text = AppLocalizations.of(context).amountTextFieldFormatter.format(widget.transaction.amount);
      _initialized = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Transaction')),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        tooltip: AppLocalizations.of(context).translate('Save'),
        onPressed: () => _save(context),
      ),
      body: _buildTransactionDetail(context)
    );
  }

  Widget _buildTransactionDetail(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      children: <Widget>[
        InputDecorator(
          decoration: InputDecoration(
            icon: Icon(Icons.account_balance_wallet),
            labelText: AppLocalizations.of(context).translate('Type')
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
                  child: Text(value.string(context))
                );
              }).toList(),
            )
          )
        ),
        TextFormField(
          controller: _amountController,
          decoration: InputDecoration(
            icon: Icon(Icons.attach_money),
            labelText: AppLocalizations.of(context).translate('Amount'),
            hintText: AppLocalizations.of(context).translate('Enter the amount'),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            WhitelistingTextInputFormatter.digitsOnly
          ],
          onChanged: (String text) {
            var value = AppLocalizations.of(context).amountTextFieldFormatter.parse(text);
            if (value != null) {
              value /= 100;
              _amountController.text = AppLocalizations.of(context).amountTextFieldFormatter.format(value);
              _amountController.selection = TextSelection.fromPosition(TextPosition(offset: _amountController.text.length));
            }
          },
        ),
        TextFormField(
          controller: _descriptionController,
          decoration: InputDecoration(
            icon: Icon(Icons.assignment),
            labelText: AppLocalizations.of(context).translate('Description'),
            hintText: AppLocalizations.of(context).translate('Enter the description')
          ),
          textCapitalization: TextCapitalization.sentences,
        ),
        InkWell(
          child: InputDecorator(
            decoration: InputDecoration(
              icon: const Icon(Icons.calendar_today),
              labelText: AppLocalizations.of(context).translate('Date'),
            ),
            child: Text(
              AppLocalizations.dateFormatOf(context, _date),
              style: Theme.of(context).textTheme.subhead,
            ),
          ),
          onTap: () => _showDateTimePicker(context),
        ),
      ],
    );
  }

  void _showDateTimePicker(BuildContext context) async {
    var date = await showDatePicker(
      initialDate: _date,
      firstDate: _date.subtract(Duration(days: 365)),
      lastDate: _date.add(Duration(days: 365)),
      context: context,
    );
    if (date != null) {
      var time = await showTimePicker(
        initialTime: TimeOfDay.fromDateTime(_date),
        context: context,
      );
      if (time != null)
        setState(() => _date = DateTime(date.year, date.month, date.day, time.hour, time.minute));
    }
  }

  void _save(BuildContext context) {
    Transaction t = widget.transaction.copyWith(
      type: _type,
      amount: AppLocalizations.of(context).amountTextFieldFormatter.parse(_amountController.text),
      description: _descriptionController.text,
      date: _date,
    );
    if (widget.store.state.transactions.contains(widget.transaction)) {
      widget.store.dispatch(EditTransactionAction(widget.transaction, t));
    } else {
      t = t.copyWith(personID: widget.person.id);
      widget.store.dispatch(AddTransactionAction(t));
      final int index = widget.store.state.getTransactionsOf(widget.person).indexOf(t);
      transactionsListKey.currentState.insertItem(index);
    }
    Navigator.of(context).pop();
  }
}