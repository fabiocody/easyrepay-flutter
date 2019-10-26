import 'package:easyrepay/helpers.dart';
import 'package:easyrepay/model.dart';
import 'package:easyrepay/views/transaction_detail.dart';
import 'package:flutter/material.dart';


class TransactionsList extends StatefulWidget {
  final Person person;
  TransactionsList(this.person);
  State createState() => _TransactionsListState();
}


class _TransactionsListState extends State<TransactionsList> {

  TextEditingController _textFieldController = TextEditingController();
  bool showCompleted = false;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(showCompleted ? Icons.check_circle : Icons.check_circle_outline),
            tooltip: 'Show completed',
            onPressed: () => setState(() => showCompleted = !showCompleted),
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _editPersonDialog(context),
            tooltip: 'Edit name',
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Transaction t = Transaction();
          setState(() {
            widget.person.transactions.add(t);
          });
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => TransactionDetail(t)
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
              children: transactions.map((t) => _buildTransactionRow(t)).toList(), 
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

  Widget _buildTransactionRow(Transaction transaction) {
    return Dismissible(
      key: Key(transaction.id),
      onDismissed: (direction) {
        setState(() {
          widget.person.transactions.remove(transaction);
        });
      },
      background: deleteBackground,
      child: ListTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(transaction.note),
                Text(
                  dateFormatter.format(transaction.date),
                  style: Theme.of(context).textTheme.caption,
                )
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            transaction.getAmountText(context),
          ],
        ),
        trailing: Icon(
          Icons.navigate_next,
          color: Theme.of(context).textTheme.caption.color
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => TransactionDetail(transaction)
            )
          );
        },
      )
    );
  }

  _editPersonDialog(BuildContext context) async {
    _textFieldController.text = widget.person.name;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Change name'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: 'Enter name'),
            autofocus: true,
            keyboardAppearance: Brightness.dark,
            onEditingComplete: _saveEditedPerson,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('CANCEL'),
              onPressed: () {
                _textFieldController.clear();
                Navigator.of(context).pop();
              }
            ),
            FlatButton(
              child: Text('SAVE', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: _saveEditedPerson,
            ),
          ],
        );
      }
    );
  }

  void _saveEditedPerson() {
    setState(() {
      widget.person.name = _textFieldController.text;
      DataStore.shared().sortPeople();
    });
    DataStore.shared().save();
    _textFieldController.clear();
    Navigator.of(context).pop();
  }

}