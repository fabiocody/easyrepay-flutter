import 'package:easyrepay/device_specifics.dart';
import 'package:easyrepay/model.dart';
import 'package:easyrepay/views/transaction_detail.dart';
import 'package:easyrepay/views/transaction_row.dart';
import 'package:flutter/material.dart';
import 'package:vibrate/vibrate.dart';


class TransactionsList extends StatefulWidget {
  final Person person;
  TransactionsList(this.person);
  State createState() => _TransactionsListState();
}


class _TransactionsListState extends State<TransactionsList> {
  bool showCompleted = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(showCompleted ? Icons.check_circle : Icons.check_circle_outline),
            tooltip: 'Show completed',
            onPressed: () {
              if (DeviceSpecifics.shared.canVibrate)
                Vibrate.feedback(FeedbackType.success);
              setState(() => showCompleted = !showCompleted);
            },
          ),
          IconButton(
            icon: Icon(Icons.add_alert),
            tooltip: 'Reminder',
            onPressed: () {
              if (DeviceSpecifics.shared.canVibrate)
                Vibrate.feedback(FeedbackType.error);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Work in progress'),
                  content: Text('This feature is not implemented yet.'),
                )
              );
            }
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (DeviceSpecifics.shared.canVibrate)
            Vibrate.feedback(FeedbackType.light);
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => TransactionDetail(widget.person, Transaction())
            )
          );
        },
        tooltip: 'New Person',
        child: Icon(Icons.add),
      ),
      body: _buildTransactionsList(context),
    );
  }

  Widget _buildTransactionsList(BuildContext context) {
    List<Transaction> transactions = widget.person.transactions;
    if (!showCompleted) {
      transactions = widget.person.transactions
        .where((transaction) => !transaction.completed)
        .toList();
    }
    if (transactions.isNotEmpty) {
      final double dividerIndent = 4;
      return ListView(
        padding: const EdgeInsets.only(top: 4),
        children: [
          Card(
            child: Column(
              children: transactions.map(
                (t) => TransactionRow(widget.person, t, showCompleted, () => setState(() => null))
              ).toList(), 
            ),
          ),
          Divider(
            indent: dividerIndent,
            endIndent: dividerIndent,
            color: Theme.of(context).textTheme.caption.color
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(child: Card(child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text('Debt', style: Theme.of(context).textTheme.title),
                    widget.person.getDebtAmountText(context)
                  ],
                ),
              ))),
              Expanded(child: Card(child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text('Credit', style: Theme.of(context).textTheme.title),
                    widget.person.getCreditAmountText(context)
                  ],
                ),
              ))),
            ],
          ),
          Row(
            children: [
              Expanded(child: Card(child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    Text('Total', style: Theme.of(context).textTheme.title),
                    widget.person.getTotalAmountText(context)
                  ],
                ),
              ))),
            ],
          )
        ],
      );
    } else {
      return Center(child: Row(
        children: <Widget>[
          Text(
            'Tap on ',
            style: Theme.of(context).textTheme.headline.copyWith(color: Theme.of(context).textTheme.caption.color),
          ),
          Icon(
            Icons.add_circle,
            color: Theme.of(context).accentColor,
            size: Theme.of(context).textTheme.headline.fontSize,
          ),
          Text(
            ' to add a transaction',
            style: Theme.of(context).textTheme.headline.copyWith(color: Theme.of(context).textTheme.caption.color)
          )
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ));
    }
  }
}