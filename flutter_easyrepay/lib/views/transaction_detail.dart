import 'package:easyrepay/app_localizations.dart';
import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vibrate/vibrate.dart';


class TransactionDetail extends StatefulWidget {
  final Transaction transaction;
  final Person person;
  TransactionDetail(this.person, this.transaction);
  State createState() => _TransactionDetailState();
}


class _TransactionDetailState extends State<TransactionDetail> {

  TransactionType _type;
  TextEditingController _amountController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  bool _completed;
  DateTime _date;
  bool _initialized = false;

  void initState() {
    super.initState();
    _type = widget.transaction.type;
    _descriptionController.text = widget.transaction.description;
    _completed = widget.transaction.completed;
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
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            tooltip: AppLocalizations.of(context).translate('Save'),
            onPressed: () => _save(context),
          )
        ],
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
                  child: Text(() {
                    switch (value) {
                      case TransactionType.credit:
                        return AppLocalizations.of(context).translate('Credit');
                      case TransactionType.debt:
                        return AppLocalizations.of(context).translate('Debt');
                      case TransactionType.settleCredit:
                        return AppLocalizations.of(context).translate('Settle credit');
                      case TransactionType.settleDebt:
                        return AppLocalizations.of(context).translate('Settle debt');
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
                AppLocalizations.of(context).translate('Completed'),
                style: Theme.of(context).textTheme.subhead,
              ),
              Switch(
                value: _completed,
                onChanged: (newValue) {
                  vibrate(FeedbackType.medium);
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
    setState(() {
      widget.transaction.type = _type;
      widget.transaction.amount = AppLocalizations.of(context).amountTextFieldFormatter.parse(_amountController.text);
      widget.transaction.description = _descriptionController.text;
      widget.transaction.completed = _completed;
      widget.transaction.date = _date;
      if (!widget.person.transactions.contains(widget.transaction)) {
        widget.person.transactions.add(widget.transaction);
      }
      widget.person.sortTransactions();
    });
    DataStore.shared().save();
    Navigator.of(context).pop();
  }
}