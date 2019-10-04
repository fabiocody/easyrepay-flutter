import 'package:easyrepay/main.dart';
import 'package:easyrepay/model_factory.dart';
import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:easyrepay/transaction_detail.dart';
import 'package:flutter/material.dart';


class TransactionsList extends StatefulWidget {
  final PBPerson person;
  TransactionsList(this.person);
  State createState() => _TransactionsListState();
}


class _TransactionsListState extends State<TransactionsList> {

  TextEditingController _textFieldController = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _editPersonDialog(context),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          PBTransaction t = ModelFactory.newTransaction();
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
    if (widget.person.transactions.isNotEmpty) {
      final Iterable<Widget> tiles = widget.person.transactions.map(
        (PBTransaction transaction) => _buildTransactionRow(transaction)
      );
      final List<Widget> rows = ListTile.divideTiles(
        context: context,
        tiles: tiles
      ).toList();
      return ListView(children: rows);
    } else {
      return Center(child: Row(
        children: <Widget>[
          Text("Tap on ", textScaleFactor: 1.1),
          Icon(Icons.add_circle, color: Colors.green),
          Text(" to add a transaction", textScaleFactor: 1.1)
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ));
    }
  }

  Widget _buildTransactionRow(PBTransaction transaction) {
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
                Text("${transaction.timestamp}", textScaleFactor: 0.75, style: TextStyle(color: Colors.grey))
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            Text("${transaction.amount}", textScaleFactor: 1.1)
          ],
        ),
        trailing: Icon(
          Icons.navigate_next,
          color: Colors.grey
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
            decoration: InputDecoration(hintText: "Enter name"),
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
              child: Text("SAVE", style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () {
                setState(() {
                  widget.person.name = _textFieldController.text;
                  ModelFactory.sortPeople();
                });
                _textFieldController.clear();
                Navigator.of(context).pop();
              }
            ),
          ],
        );
      }
    );
  }

}