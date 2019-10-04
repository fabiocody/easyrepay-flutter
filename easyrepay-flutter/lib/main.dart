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


class _PeopleListState extends State<PeopleList> {

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
        onPressed: () {
          setState(() {
            widget.store.people.add(ModelFactory.newPerson());
          });
        },
        tooltip: 'New Person',
        child: Icon(Icons.add),
      )
    );
  }

  Widget _buildPeopleList(BuildContext context) {
    final Iterable<Widget> tiles = widget.store.people.map(
      (PBPerson person) => _buildPersonRow(person)
    );
    final List<Widget> rows = ListTile.divideTiles(
      context: context,
      tiles: tiles
    ).toList();
    return ListView(children: rows);
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
    final Iterable<Widget> tiles = widget.person.transactions.map(
      (PBTransaction transaction) => _buildTransactionRow(transaction)
    );
    final List<Widget> rows = ListTile.divideTiles(
      context: context,
      tiles: tiles
    ).toList();
    return ListView(children: rows);
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
                Text("${transaction.timestamp}", style: TextStyle(fontSize: 12))
              ],
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            Spacer(),
            Text("${transaction.amount}")
          ],
        ),
        trailing: Icon(
          Icons.navigate_next,
          color: Colors.grey
        ),
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