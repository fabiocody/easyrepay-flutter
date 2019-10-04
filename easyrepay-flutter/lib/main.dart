import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:easyrepay/proto/easyrepay.pb.dart';
import 'package:easyrepay/model_factory.dart';


void main() => runApp(MaterialApp(
  title: "EasyRepay",
  home: PeopleList(ModelFactory.getStore()),
  theme: ThemeData(
    primarySwatch: Colors.green,
  )
));


class PeopleList extends StatefulWidget {
  final PBDataStore store;
  PeopleList(this.store);
  State createState() => _PeopleListState();
}


class TransactionsList extends StatefulWidget {
  final PBPerson person;
  TransactionsList(this.person);
  State createState() => _TransactionsListState();
}


class TransactionDetail extends StatefulWidget {
  final PBTransaction transaction;
  TransactionDetail(this.transaction);
  State createState() => _TransactionDetailState();
}


class _PeopleListState extends State<PeopleList> {

  TextEditingController _textFieldController = TextEditingController();

  void initState() {
    super.initState();
    if (kReleaseMode) {
      // RELEASE
    } else {
      // DEBUG
      ModelFactory.getDebugData(widget.store);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("EasyRepay")
      ),
      body: _buildPeopleList(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _newPersonDialog(context),
        tooltip: 'New Person',
        child: Icon(Icons.add),
      )
    );
  }

  Widget _buildPeopleList(BuildContext context) {
    if (widget.store.people.isNotEmpty) {
      final Iterable<Widget> tiles = widget.store.people.map(
        (PBPerson person) => _buildPersonRow(person)
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
          Text(" to add a person", textScaleFactor: 1.1)
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
      ));
    }
  }

  Widget _buildPersonRow(PBPerson person) {
    return Dismissible(
      key: Key(person.id),
      onDismissed: (direction) {
        setState(() {
          widget.store.people.remove(person);
        });
      },
      background: deleteBackground,
      child: ListTile(
        title: Text(person.name),
        trailing: Icon(
          Icons.navigate_next,
          color: Colors.grey
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => TransactionsList(person)
            )
          );
        },
      )
    );
  }

  _newPersonDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('New person'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(hintText: "Enter name"),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      }
    );
  }

}


class _TransactionsListState extends State<TransactionsList> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.name)
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            widget.person.transactions.add(ModelFactory.newTransaction());
          });
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
          children: <Widget>[
            Column(
              children: <Widget>[
                Text(transaction.note),
                Text("${transaction.timestamp}", textScaleFactor: 0.75,)
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            Spacer(),
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

}


class _TransactionDetailState extends State<TransactionDetail> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaction")
      ),
      body: Center(
        child: Text("Hello, world!", textScaleFactor: 3)
      )
    );
  }

}


var deleteBackground = Container(
  padding: const EdgeInsets.only(right: 8),
  color: Colors.red,
  child: Column(
    children: <Widget>[
      Text("Delete", 
        style: TextStyle(
          fontSize: 16, 
          color: Colors.white
        ),
      ),
    ],
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.end,
  ),
);